class UsersController < ApplicationController

    skip_before_filter :just_teacher
    def activities
        user = User.find(params[:id])
        render json: user.activities
    end

    def users_courses
        courses = []
        studentCourses = Student.where(user_id: params[:user_id])
        studentCourses.each do |course|
            data_course = Course.find(course[:course_id])
            data_course = {:users_type => "Student",
                            :course_id => data_course[:id],
                            :id => data_course[:id],
                            :name => data_course[:name],
                            :period => data_course[:period]}
            courses.push(data_course)
        end
        if courses.any?
            render json: courses, status: 200
        else
            render json: 'No tiene cursos', status: 404
        end
    end

    def users_activities
        activities = []
        studentActivities = Activity.where(course_id: params[:course_id])
        studentActivities.each do |activity|
            data_activity = Activity.find(activity[:id])
            data_activity = {:users_type => "Student",
                            :course_id => params[:course_id],
                            :id => data_activity[:id],
                            :name_activity => data_activity[:name_activity], 
                            :range => data_activity[:range], 
                            :latitude => data_activity[:latitude], 
                            :longitude => data_activity[:longitude], 
                            :start_date => data_activity[:start_date], 
                            :finish_date => data_activity[:finish_date],
                            :duration => data_activity[:duration]}
            activities.push(data_activity)
        end
        if activities.any?
            render json: activities, status: 200
        else
            render json: 'No tiene actividades', status: 404
        end
    end

    def users_all_activities
        activities = []
        studentCourses = Student.where(user_id: params[:user_id])
        studentCourses.each do |student_item|
            studentActivities_course  = student_item.activities
            studentActivities_course  = studentActivities_course.collect{|data_activity| 
                {:users_type => "Student",
                :course_id => data_activity.course_id,
                :id => data_activity.id,
                :name_activity => data_activity.name_activity, 
                :range => data_activity.range, 
                :latitude => data_activity.latitude, 
                :longitude => data_activity.longitude, 
                :start_date => data_activity.start_date, 
                :finish_date => data_activity.finish_date,
                :duration => data_activity.duration}
            }
            activities += studentActivities_course
        end
        if activities.any?
            render json: activities, status: 200
        else
            render json: 'No tiene actividades', status: 404
        end
    end

    def users_all_groups
        groups = []
        user = User.find(params[:user_id])
        courses = Course.where(user_id: user[:id])
        courses.each do |course|
            activities = Activity.where(course_id: course[:id])
            activities.each do |activity|
                groups += activity.groups.collect{ |group|
                    {course_id: course.id,
                    activity_id: activity.id,
                    name_group: group.name_group,
                    users_type: user.users_type,
                    id: group.id}
                }
            end
        end
        if groups.any?
            render json: groups, status: 201
        else
            render json: ['No existen grupos'], status: 422
        end
    end

    def students
        user = User.find(params[:id])
        students = user.students.collect{|student| {id: student.id, email: student.user.email, first_name: student.user.first_name, last_name: student.user.last_name, course: student.course}}
        if students
          render json: students, status: 201  
        else
          render json: students.errors, status: 422
        end
    end

    def import
        error_data = []
        successful_data = []
        content = params.values[0]
        data_users = content.split("\r\n\r\n﻿")
        data_users[1].split("\n")[1..-3].each do |data|
            atributos = data.split(",")
            p atributos
            information = {:last_name => atributos[0].gsub(/["\\]/, '').to_s,
                        :first_name => atributos[1].gsub(/["\\]/, '').to_s,
                        :users_type => 'Student',
                        :password => atributos[3].gsub(/["\\]/, '').to_s,
                        :email => atributos[2].gsub(/["\\]/, '').to_s + '@uninorte.edu.co'}
            user = User.new(information)
            if user.save or User.find_by(email: information[:email])
                successful_data.push(information[:email])
            else
                error_data.push(information[:email])
            end
        end
        response = {:error_data => error_data,
                    :successful_data => successful_data}
        p response
        render json: response, status: 200
    end

    def student_courses
        p params
        user = User.find(params[:user_id])
        course = user.courses.find(params[:course_id])
        students = course.students.collect{|student| {id: student.id, email: student.user.email, first_name: student.user.first_name, last_name: student.user.last_name, course: student.course}}
        if students
          render json: students, status: 201  
        else
          render json: students.errors, status: 422
        end
    end
end
