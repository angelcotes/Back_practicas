class UsersController < ApplicationController

    skip_before_filter :just_teacher
    def activities
        myActivities = []
        user = User.find(params[:id])
        allActivities = user.activities
        allActivities.each do |activity|
            course = Course.find(activity[:course_id])
            activity = {
                :users_type => user.users_type,
                :course_nrc => course.nrc,
                :id => activity[:id],
                :name_activity => activity[:name_activity], 
                :range => activity[:range], 
                :latitude => activity[:latitude], 
                :longitude => activity[:longitude], 
                :start_date => activity[:start_date], 
                :finish_date => activity[:finish_date],
                :duration => activity[:duration]
            }
            myActivities.push(activity)
        end
        if myActivities.any?
            render json: myActivities, status: 200 
        end
    end

    def startActivity
        activity = Activity.find(params[:activity_id])
        group = Group.where(activity_id: activity[:id]).first
        member = group.members.where(user_id: params[:id]).first
        if member.duration.nil?
            if activity.start_date <= params[:time].to_datetime and activity.finish_date >= params[:time]
                data = {
                    status: params[:estado], 
                    time_start: params[:time].to_datetime,
                    duration: activity.duration,
                    time_pause: params[:time].to_datetime
                }
                if member.update(data)
                    render json: {:sms => 'Actividad iniciada'}, status: 200
                else
                    p '-' * 10
                    p member.errors
                    render json: member.errors, status: 422
                end 
            else
                render json: {:sms => 'No puede iniciar esta actividad por las fechas establecidas'}, status: 422
            end
        elsif member.duration > 0
            p "no es nulo"
            if activity.start_date >= params[:time].to_datetime and activity.finish_date <= params[:time]
                if  member.status == "pausado"
                    data = {
                        status: params[:estado],
                        time_pause: params[:time]
                    }
                    if member.update(data)
                        redner json: {:sms => 'Actividad inicada'}, status: 200
                    end  
                elsif  member.status == "ejecutado"
                    if params[:estado] == "pausado"
                       data = {
                            status: params[:estado], 
                            duration: member.duration - (params[:time].to_datetime - member.time_pause),
                            time_pause: params[:time]
                        }
                        if member.update(data)
                            render json: {:sms => 'La actividad se ha interrumpido'}, status: 200
                        end
                    elsif params[:estado] == 'finalizado'
                        data = {
                            status: params[:estado], 
                            duration: 0,
                            time_finished: params[:time]
                        }
                        if member.update(data)
                            render json: {:sms => 'Actividad finalizada'}, status: 200
                        end
                    else render json: '', status: 200
                    end
                else
                    render json: {:sms => 'Actividad finalizada'}, status: 422
                end
            else
                render json: {:sms => 'No puede iniciar esta actividad por las fechas establecidas'}, status: 422
            end
        else
            render json: {:sms => 'Se acabó el tiempo de ejecución de la activdad'}, status: 422
        end
    end

    def users_courses
        courses = []
        studentCourses = Student.where(user_id: params[:user_id])
        studentCourses.each do |course|
            data_course = Course.find(course[:course_id])
            data_course = {:users_type => "Student",
                            :course_nrc => data_course.nrc,
                            :id => data_course[:id],
                            :name => data_course[:name],
                            :period => data_course[:period]}
            courses.push(data_course)
        end
        if courses.any?
            render json: courses, status: 200
        end
    end

    def users_activities
        activities = []
        studentActivities = Activity.where(course_id: params[:course_id])
        studentActivities.each do |activity|
            data_activity = Activity.find(activity[:id])
            course = Course.find(params[:course_id])
            data_activity = {:users_type => "Student",
                            :course_nrc => course.nrc,
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
        end
    end

    def users_all_activities
        activities = []
        studentCourses = Student.where(user_id: params[:user_id])
        studentCourses.each do |student_item|
            studentActivities_course  = student_item.activities
            studentActivities_course  = studentActivities_course.collect{|data_activity|
                course = Course.find(data_activity.course_id) 
                {:users_type => "Student",
                :course_nrc => course.nrc,
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
        end
    end

    def allGroupStudent
        groups = []
        user = User.find(params[:id])
        member = Member.where(user_id: params[:id])
        member.each do |data_member|
            groups = Group.find(data_member.group_id)
        end
        if !groups.nil?
            render json: {:sms => groups, :users_type => user.users_type}, status: 200
        else
            render json: {:sms => 'No hay grupos'}, status: 422
        end
    end

    def groupStudent
        group = []
        activity = Activity.find(params[:activity_id])
        user = User.find(params[:user_id])
        members = Member.where(user_id: user.id)
        groups = Group.where(activity_id: params[:activity_id])
        groups.each do |data_group|  
            members.each do |data_member|  
                if data_member.group_id == data_group.id
                    group += {
                        id: data_group.id,
                        name_group: data_group.name_group,
                        course_id: activity.course_id,
                        activity_id: activity.id
                    }
                end
            end
        end
        if !group.nil?
            render json: {:sms => group, :users_type => user.users_type}, status: 200
        else
            render json: {:sms => 'No hay grupos'}, status: 422
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
                    {course_nrc: course.nrc,
                    activity_id: activity.id,
                    name_group: group.name_group,
                    users_type: user.users_type,
                    id: group.id}
                }
            end
        end
        if groups.any?
            render json: groups, status: 201
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

    def members_group
        students_without_group = []
        group_members = []
        user = User.find(params[:user_id])
        course = Course.where(nrc: params[:course_id])
        groups = Group.where(activity_id: Group.find(params[:group_id]).activity_id)
        p students = Student.where(course_id: course.ids)
        students.each do |student|
            if find_member(student, Member.all)
               userStudent = User.find(student.user_id)
               userStudent = {
                email: userStudent[:email],
                first_name: userStudent[:first_name],
                last_name: userStudent[:last_name],
                user_id: student[:user_id],
                group_id: params[:group_id]
               }
               students_without_group.push(userStudent) 
            end
        end
        members = Member.where(group_id: params[:group_id])
        members.each do |member|
            userMember = User.find(member.user_id)
            userMember = {
                email: userMember[:email],
                first_name: userMember[:first_name],
                last_name: userMember[:last_name],
                rol: member[:rol],
                user_id: member[:user_id],
                group_id: params[:group_id]
            }
            group_members.push(userMember)
        end  
        if user.users_type == 'Teacher'
            response = {:student_course => students_without_group, :members_group => group_members}
            render json: response, status: 200
        else
            render json: 'Usuario no autorizado', status: 422
        end
    end

    def enroll_member
        error_data = []
        successful_data = []
        user = User.find(params[:user_id])
        users_members = params[:_json]
        if user.users_type == "Teacher"
            users_members.each do |user_mem|
                error = 0
                user_mem.each do |key, value|
                    error = 1 if value.nil?
                end
                members_groups = Member.where(group_id: user_mem[:group_id])
                members_groups.each do |member|
                    member.destroy if find_member(member, users_members)
                end
                if error == 1
                    error_data.push(user_mem)
                else
                    if Member.exists?(:user_id => user_mem[:user_id])
                        memberF = Member.where(:user_id => user_mem[:user_id])
                        Member.destroy(memberF.ids)
                        member = Member.new({group_id: user_mem[:group_id], user_id: user_mem[:user_id], rol: user_mem[:rol]}) 
                        member.save
                        successful_data.push(member)
                    else
                        member = Member.new({group_id: user_mem[:group_id], user_id: user_mem[:user_id], rol: user_mem[:rol]}) 
                        if member.save
                            successful_data.push(user_mem)
                        else
                            error_data.push(user_mem)     
                        end 
                    end
                end
            end
            if error_data.length == 0
                response = {:error => error_data, :success => successful_data}
                render json: response, status: 200
            else
                response = {:error => error_data, :success => successful_data}
                render json: response, status: 422
            end 
        else
            render json: 'Usuario no autorizado', status: 422
        end       
    end

    def import
        error_data = []
        successful_data = []
        content = params.values[0]
        data_users = content.split("\r\n\r\n﻿")
        data_users[1].split("\n")[1..-3].each do |data|
            atributos = data.split(",")
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
        render json: response, status: 200
    end

    def student_courses
        user = User.find(params[:user_id])
        course = user.courses.find(params[:course_id])
        students = course.students.collect{|student| {id: student.id, email: student.user.email, first_name: student.user.first_name, last_name: student.user.last_name, course: student.course}}
        if students
          render json: students, status: 201  
        else
          render json: students.errors, status: 422
        end
    end

    def find_member(member, list)
        list.each do |user|
            return false if user[:user_id] == member[:user_id]
        end
        return true
    end
end
