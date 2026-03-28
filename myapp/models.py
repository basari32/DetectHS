from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class Authority_table(models.Model):
    auth_name=models.CharField(max_length=100)
    Login=models.ForeignKey(User,on_delete=models.CASCADE)
    phoneNo=models.BigIntegerField()
    Email=models.EmailField(max_length=100)
    photo=models.FileField()
    position=models.CharField(max_length=100)
    dob=models.DateField()
    gender=models.CharField(max_length=100)

class userProfile(models.Model):
    Login=models.ForeignKey(User,on_delete=models.CASCADE)
    name=models.CharField(max_length=100)
    Gender = models.CharField(max_length=100)
    dob = models.DateField()
    photo = models.FileField()
    phone = models.BigIntegerField()
    Email = models.CharField(max_length=100)

class Report_table(models.Model):
    user= models.ForeignKey(userProfile, on_delete=models.CASCADE)
    Authority=models.ForeignKey(Authority_table, on_delete=models.CASCADE)
    Date=models.DateField()
    report_type=models.CharField(max_length=100)
    Audio=models.FileField(max_length=100)
    latitude=models.FloatField()
    longitude=models.FloatField()
    status=models.CharField(max_length=100)

class Awareness_table(models.Model):
    authority= models.ForeignKey(Authority_table, on_delete=models.CASCADE,default='')
    title=models.CharField(max_length=100)
    file=models.FileField()
    description=models.TextField()
    punishment=models.TextField()
    date=models.DateField(max_length=100)

class complaint(models.Model):
    USER = models.ForeignKey(userProfile,on_delete=models.CASCADE,default='')
    authority= models.ForeignKey(Authority_table, on_delete=models.CASCADE,default='')
    complaint = models.CharField(max_length=100)
    Date=models.DateField(max_length=100)
    reply=models.CharField(max_length=100)

class Feedback(models.Model):
    USER = models.ForeignKey(userProfile,on_delete=models.CASCADE,default='')
    authority= models.ForeignKey(Authority_table, on_delete=models.CASCADE,default='')
    feedback=models.CharField(max_length=100)
    rating=models.CharField(max_length=100)
    date=models.DateField()


