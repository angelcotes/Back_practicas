class UsersController < ApplicationController

    skip_before_filter :just_teacher


    def deleteDocument
        document = Document.find(params[:document_id])
        document.destroy
        render json: document
    end

    def save_document
        member = Member.where({user_id: params[:user_id], group_id: params[:group_id]}).first
        data_final = {
            type_document:  params[:file].original_filename,
            address: params[:file],
            member_id: member.user_id,
            group_id: member.group_id
        }
        document = Document.new(data_final)
        if document.save
          render json: document, status: 201
        else
          render json: document.errors, status: 422
        end
    end

    def activities
        myActivities = []
        user = User.find(params[:id])
        p allActivities = user.activities
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
        finish_time = nil
        activity = Activity.find(params[:activity_id])
        group = Group.where(activity_id: activity[:id]).first
        p member = Member.where({user_id: params[:id], group_id: group.id}).first
        fecha =  DateTime.now.in_time_zone;
        times = fecha + activity.duration * 60
        if member.status == "habilitado"
            if activity.start_date <= fecha and activity.finish_date >= fecha
                if times <= activity.finish_date
                    @data = {
                        status: "finalizado",
                        time_start: fecha,
                        time_finished: times
                    }
                else
                    @data = {
                        status: "finalizado",
                        time_start: fecha,
                        time_finished: activity.finish_date
                    }
                    times = activity.finish_date
                end
                p @data
                if member.update(@data)
                    render json: {:sms => 'Actividad iniciada', :finish => times}, status: 200
                else
                    render json: {:sms => 'No se pudo iniciar la actividad'}, status: 422
                end
            else
                if fecha < activity.start_date
                    render  json: {:sms => 'La actividad no ha iniciado'}, status: 422
                elsif fecha > activity.finish_date
                    render  json: {:sms => 'La actividad ha finzalizado'}, status: 422
                else
                    render json: {:finish => @data.time_finished}, status: 200
                end
            end
        else
            render  json: {:sms => 'La actividad ha finzalizado'}, status: 422
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

    def membersGroup
        data_members = []
        documents_group = []
        members = Member.where(group_id: params[:group_id])
        group = Group.find(params[:group_id])
        activity = Activity.find(group.activity_id)
        members.each do |member|
            user = User.find(member[:user_id])
            documents = Document.where({member_id: user.id, group_id: params[:group_id]})
            final_data = {
                last_name: user.last_name,
                first_name: user.first_name,
                rol: member[:rol],
                latitude: activity.latitude,
                longitude: activity.longitude,
                activity_id: activity.id,
                user_id: user.id,
                range: activity.range,
                time_start: member.time_start,
                time_finished: member.time_finished
            }
            if documents
                documents.each do |document|
                    documents_group.push({first_name: user.first_name, url: request.base_url + document.file_path, id: user.id, name: document.type_document})
                end
            end
            data_members << final_data
        end
        if data_members.any?
            render json: {:data => data_members, :documents => documents_group}, status: 200
        else
            render json: {:sms => 'No existen miembros en ese grupo'}, status: 422
        end
    end

    def allGroupStudent
        groups = []
        user = User.find(params[:id])
        member = Member.where(user_id: params[:id])
        member.each do |data_member|
            group = Group.find(data_member.group_id)
            groups << {
                id: group.id,
                name_group: group.name_group,
                activity_id: group.activity_id,
                users_type: user.users_type,
                user_id: data_member.user_id
            }
        end
        if !groups.nil?
            render json: groups, status: 200
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
                    group << {
                        id: data_group.id,
                        name_group: data_group.name_group,
                        course_id: activity.course_id,
                        activity_id: activity.id,
                        users_type: user.users_type
                    }
                end
            end
        end
        if !group.nil?
            render json: group, status: 200
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
        course = Course.where(nrc: params[:course_id]).first
        students = Student.where(course_id: course.id)
        students.each do |student|
            if Member.where({user_id: student.user_id, group_id: params[:group_id]}).first
               userStudent = User.find(student.user_id)
               member = Member.where({user_id: student.user_id, group_id: params[:group_id]}).first
               userStudent = {
                email: userStudent[:email],
                first_name: userStudent[:first_name],
                last_name: userStudent[:last_name],
                user_id: student[:user_id],
                group_id: params[:group_id],
                rol: member.rol
               }
               group_members.push(userStudent)
            else
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
                    member.destroy if find_member_enroll(member, users_members)
                end
                if error == 1
                    error_data.push(user_mem)
                else
                    if !Member.where({user_id: user_mem[:user_id], group_id: user_mem[:group_id]}).first.nil?
                        memberF = Member.where({user_id: user_mem[:user_id], group_id: user_mem[:group_id]}).first
                        Member.destroy(memberF.id)
                        member = Member.new({group_id: user_mem[:group_id], user_id: user_mem[:user_id], rol: user_mem[:rol]})
                        if member.save
                            successful_data.push(member)
                        else
                            error_data.push(member)
                        end
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

    def find_member(member, list, group)
        list.each do |user|
            return false if group == user[:group_id] and user[:user_id] == member[:user_id]
        end
        return true
    end

    def find_member_enroll(member, list)
        list.each do |user|
            return false if user[:user_id] == member[:user_id]
        end
        return true
    end
end
