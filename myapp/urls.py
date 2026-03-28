"""
URL configuration for detecths project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path

from myapp import views

urlpatterns = [
    path('login_get/',views.login_get),
    path('authority_get/',views.authority_get),
    path('complaint_get/',views.complaint_get),
    path('editauthority_get/<id>',views.editauthority_get),
    path('deleteauthority/<id>',views.deleteauthority),
    path('editauthority_post/',views.editauthority_post),
    path('feedback_get/',views.feedback_get),
    path('home_get/',views.home_get),
    path('reporthistory_get/',views.reporthistory_get),
    path('sendreply_post/',views.sendreply_post),
    path('sendreply_get/<id>',views.sendreply_get),
    path('viewauthority_get/',views.viewauthority_get),
    path('viewuser_get/',views.viewuser_get),
    path('login_post/',views.login_post),
    path('add_authority_post/',views.add_authority_post),
    path('authorityProfile/',views.authorityProfile),
    path('AuthorityupdateProfile/',views.AuthorityupdateProfile),

    path('view_user_authority/',views.view_user_authority),
    path('user_registration/',views.user_registration),
    path('FlutterLogin/',views.FlutterLogin),
    path('view_user_report_authority/',views.view_user_report_authority),
    path('view_complaint/',views.view_complaint),
    path('send_reply/',views.send_reply),
    path('view_feedback/',views.view_feedback),
    path('audioupload/',views.audioupload),
    path('UpdateStatus/',views.UpdateStatus),
    path('UserViewReportHistory/',views.UserViewReportHistory),


    path('UserViewAuthority/',views.UserViewAuthority),
    path('SendComplaint/',views.SendComplaint),
    path('UserViewComplaintResponse/',views.UserViewComplaintResponse),
    path('SendFeedback/',views.SendFeedback),
    path('AddAwarness/',views.AddAwarness),
    path('view_awarness/',views.view_awarness),
    path('delete_awarness/',views.delete_awarness),
    path('UserViewAwarness/',views.UserViewAwarness),
    path('UserViewAwarness/',views.UserViewAwarness),
    path('SendReport/',views.SendReport),
    path('UserProfile/',views.UserProfile),
    path('UserupdateProfile/',views.UserupdateProfile),


]


