from datetime import datetime

from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.core.files.storage.filesystem import FileSystemStorage
from django.http import JsonResponse
from django.shortcuts import render, redirect
from django.contrib.auth.models import User, Group

# Create your views here.
from myapp.models import *


def login_get(request):
    return render(request,'login.html')


def login_post(request):
    username = request.POST['username']
    password = request.POST['password']

    ob = authenticate(request, username=username, password=password)
    if ob is not None:
        if ob.groups.filter(name='Admin').exists():
            login(request, ob)
            return redirect('/myapp/home_get/')
        else:
            messages.error(request, 'invalid username or password')
            return redirect('/myapp/login/')
    else:
        messages.error(request, 'invalid username or password')
        return redirect('/myapp/login_get/')
def authority_get(request):
    return render(request,'authority.html')

def add_authority_post(request):
    name=request.POST['name']
    phone=request.POST['phone']
    email=request.POST['email']
    photo=request.FILES['photo']
    position=request.POST['position']
    dob=request.POST['dob']
    Gender=request.POST['gender']
    username=request.POST['username']
    password=request.POST['password']

    user=User.objects.create_user(username=username,password=password)
    user.save()
    user.groups.add(Group.objects.get(name="authority"))

    a=Authority_table()
    a.auth_name=name
    a.Login=user
    a.phoneNo=phone
    a.Email=email
    a.photo=photo
    a.position=position
    a.dob=dob
    a.gender=Gender
    a.save()
    return redirect('/myapp/viewauthority_get/')
def complaint_get(request):
    a=complaint.objects.all()
    return render(request,'complaint.html',{"data":a})


def deleteauthority(request,id):
    a = Authority_table.objects.get(id=id)
    User.objects.get(id=a.Login.id).delete()
    return redirect('/myapp/viewauthority_get/')

def editauthority_get(request,id):
    request.session['aid']=id
    a=Authority_table.objects.get(id=id)
    return render(request,'authorityedit.html',{"data":a})

def editauthority_post(request):
    name=request.POST['name']
    phone=request.POST['phone']
    email=request.POST['email']

    position=request.POST['position']
    dob=request.POST['dob']
    Gender=request.POST['gender']
    a=Authority_table.objects.get(id=request.session['aid'])
    a.auth_name=name
    a.phoneNo=phone
    a.Email=email
    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        a.photo=photo
    a.position=position
    a.dob=dob
    a.gender=Gender
    a.save()
    return redirect('/myapp/viewauthority_get/')
def feedback_get(request):
    a=Feedback.objects.all()
    return render(request,'feedback.html',{"data":a})
def home_get(request):
    return render(request,'home.html')
def reporthistory_get(request):
    ob=Report_table.objects.all()
    return render(request,'reporthistory.html',{"data":ob})
def sendreply_get(request,id):
    request.session['cid']=id
    return render(request,'sendreply.html')
def sendreply_post(request):
    reply=request.POST['reply']
    complaint.objects.filter(id=request.session['cid']).update(reply=reply)
    return redirect('/myapp/complaint_get/')

def viewauthority_get(request):
    a = Authority_table.objects.all()
    return render(request,'viewauthority.html',{"data":a})
def viewuser_get(request):
    a = userProfile.objects.all()
    return render(request,'viewuser.html',{"data":a})


############################# flutter ###############

def FlutterLogin(request):
    username = request.POST.get('username')
    password = request.POST.get('password')

    user = authenticate(request, username=username, password=password)
    if user is not None:
        if user.groups.filter(name="authority").exists():
            login(request,user)
            return JsonResponse({'status':'authority','lid':user.id,'type':'authority'})
        elif user.groups.filter(name="User").exists():
            login(request,user)
            return JsonResponse({'status':'User','lid':user.id,'type':'User'})
        else:
            print("**************************")
    return JsonResponse({'status':'no'})

def authorityProfile(request):
    lid=request.POST['lid']
    ob=Authority_table.objects.get(Login_id=lid)
    data={
        'name':ob.auth_name,
        'phoneNo':ob.phoneNo,
        'Email':ob.Email,
        'photo':ob.photo.url,
        'position':ob.position,
        'dob':ob.dob,
        'gender':ob.gender,
    }
    return JsonResponse({'status':'ok','data':data})


def UserProfile(request):
    lid=request.POST['lid']
    ob=userProfile.objects.get(Login_id=lid)
    # name=models.CharField(max_length=100)
    # Gender = models.CharField(max_length=100)
    # dob = models.DateField()
    # photo = models.FileField()
    # phone = models.BigIntegerField()
    # Email =
    data={
        'name':ob.name,
        'phoneNo':ob.phone,
        'Email':ob.Email,
        'photo':ob.photo.url,

        'dob':ob.dob,
        'gender':ob.Gender,
    }
    return JsonResponse({'status':'ok','data':data})


def AuthorityupdateProfile(request):
    lid = request.POST['lid']
    a = Authority_table.objects.get(Login__id=lid)
    a.auth_name = request.POST['name']
    a.phoneNo = request.POST['phone']
    a.Email = request.POST['email']
    a.position = request.POST['position']
    a.dob = request.POST['dob']
    a.gender = request.POST['gender']

    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        a.photo = photo

    a.save()
    return JsonResponse({'status': 'ok'})

def UserupdateProfile(request):
    lid = request.POST['lid']

    a = userProfile.objects.get(Login__id=lid)
    a.name = request.POST['name']
    a.phone = request.POST['phone']
    a.Email = request.POST['email']
    a.dob = request.POST['dob']
    a.Gender = request.POST['gender']

    if 'photo' in request.FILES:
        photo = request.FILES['photo']
        a.photo = photo

    a.save()
    return JsonResponse({'status': 'ok'})

def view_user_authority(request):
    a=userProfile.objects.all()
    l=[]
    for i in a:
        l.append({"id":str(i.id),
                  "name":i.name,
                  "Gender":i.Gender,
                  "dob":i.dob,
                  "photo":i.photo.url,
                  "Email":i.Email,
                  })

    return JsonResponse({"status":"ok","data":l})

         #############authority#############

def view_user_report_authority(request):
    lid=request.POST['lid']

    a = Report_table.objects.filter(Authority__Login__id=lid)
    l = []
    for i in a:
        l.append({"id": str(i.id),
                  "name": i.user.name,
                  "Gender": i.user.Gender,
                  "dob": i.user.dob,
                  "status": i.status,
                  "Date": i.Date,
                  "Detected": i.report_type,
                  "Audio": i.Audio.url,
                  "photo": i.user.photo.url,
                  "loc": "http://maps.google.com?q="+str(i.latitude)+","+str(i.longitude),
                  })
    return JsonResponse({"status":"ok","data":l})

def UpdateStatus(request):
    id=request.POST['id']
    ob=Report_table.objects.get(id=id)
    ob.status='Reviewed'
    ob.save()
    return JsonResponse({'status':'ok'})



def view_complaint(request):
    lid=request.POST['lid']
    print(lid,'llllllllllllll')
    a = complaint.objects.filter(authority__Login_id=lid)
    print(a,'aaaaaaaaaaaaaaaaaaaa')
    l = []
    for i in a:
        l.append({
            "id": str(i.id),
            "USER": i.USER.name,
            "authority": i.authority.auth_name,
            "complaint": i.complaint,
            "Date": str(i.Date),
            "reply": i.reply if i.reply else "pending",
        })
        print(l,'kkkkkkkkkkkkkkkkk')

    print(l,'ll')
    return JsonResponse({"status": "ok", "data": l})


def view_complaint(request):
    if request.method == "POST":
        lid = request.POST.get('lid')

        if not lid:
            return JsonResponse({"status": "error", "message": "lid required"})

        complaints = complaint.objects.filter(authority__Login_id=lid)

        data = []
        for i in complaints:
            data.append({
                "id": str(i.id),
                "USER": i.USER.name,
                "authority": i.authority.auth_name,
                "complaint": i.complaint,
                "Date": str(i.Date),
                "reply": i.reply.strip() if i.reply else "pending",
            })

        return JsonResponse({"status": "ok", "data": data})

    return JsonResponse({"status": "error", "message": "invalid request"})




def send_reply(request):
    reply=request.POST['reply']
    cid=request.POST['cid']
    a=complaint.objects.get(id=cid)
    a.reply=reply
    a.save()
    return JsonResponse({"status":"ok"})

def AddAwarness(request):
    lid=request.POST['lid']
    title=request.POST['title']
    file=request.FILES['file']
    description=request.POST['description']
    punishment=request.POST['punishment']
    ob=Awareness_table()
    ob.title=title
    ob.file=file
    ob.description=description
    ob.punishment=punishment
    ob.date=datetime.today()
    ob.authority=Authority_table.objects.get(Login__id=lid)
    ob.save()
    return JsonResponse({'status':'ok'})

def view_feedback(request):
    # Fetching related USER data to avoid multiple DB hits
    a = Feedback.objects.all().select_related('USER', 'authority')
    l = []
    for i in a:
        l.append({
            "id": str(i.id),
            "user_name": i.USER.name, # Extracting the name string
            "authority_name": i.authority.auth_name,
            "feedback": i.feedback,
            "rating": i.rating,
            "date": i.date.strftime("%Y-%m-%d"), # Formatting date for Flutter
        })
    return JsonResponse({"status":"ok", "data":l})

def view_awarness(request):
    lid=request.POST['lid']
    a = Awareness_table.objects.filter(authority__Login_id=lid)
    l = []
    for i in a:
        l.append({"id": str(i.id),
                  "title": i.title,
                  "description": i.description,
                  "punishment": i.punishment,
                  "file": request.build_absolute_uri(i.file.url)if i.file else "",
                  "date": i.date,
                  })
    return JsonResponse({"status": "ok",'data':l})

def delete_awarness(request):
    id = request.POST['id']
    Awareness_table.objects.filter(id=id).delete()
    return JsonResponse({'status': 'ok'})

        ########user########

def user_registration(request):
    name=request.POST['name']
    Gender=request.POST['Gender']
    dob=request.POST['dob']
    photo=request.FILES['photo']
    Email=request.POST['Email']
    phone=request.POST['phone']
    username=request.POST['username']
    password=request.POST['password']
    ob=userProfile()
    ob.name=name
    ob.Gender=Gender
    ob.dob=dob
    ob.photo=photo
    ob.phone=phone
    ob.Email=Email
    if User.objects.filter(username=username).exists():
        return JsonResponse({'status':'username_exists'})
    user=User.objects.create_user(username=username,password=password)
    user.save()
    user.groups.add(Group.objects.get(name='User'))
    ob.Login=user
    ob.save()
    return JsonResponse({'status':'ok'})


def SendReport(request):
    lid=request.POST['lid']
    Authority=request.POST['Authority']
    Audio=request.FILES['Audio']
    latitude=request.POST['latitude']
    longitude=request.POST['longitude']
    ob=Report_table()
    ob.user=userProfile.objects.get(Login__id=lid)
    ob.Authority_id=Authority
    ob.Date=datetime.today()
    ob.Audio=Audio
    ob.latitude=latitude
    ob.longitude=longitude
    ob.status='pending'
    ob.save()
    return JsonResponse({'status':'ok'})

def SendComplaint(request):
    lid=request.POST['lid']
    authority=request.POST['authority']
    complaints=request.POST['complaint']
    ob=complaint()
    ob.USER=userProfile.objects.get(Login__id=lid)
    ob.complaint=complaints
    ob.Date=datetime.today()
    ob.reply='pending'
    ob.authority_id=authority
    ob.save()
    return JsonResponse({'status':'ok'})

def SendFeedback(request):
    lid=request.POST['lid']
    authority=request.POST['authority']
    feedback=request.POST['feedback']
    rating=request.POST['rating']
    ob=Feedback()
    ob.authority_id=authority
    ob.feedback=feedback
    ob.rating=rating
    ob.date=datetime.today()
    ob.USER=userProfile.objects.get(Login__id=lid)
    ob.save()
    return JsonResponse({'status':'ok'})



######view_functions_user######

def UserViewAuthority(request):
    ob=Authority_table.objects.all()
    mdata=[]
    for i in ob:
        data={
            'id':str(i.id),
            'auth_name':str(i.auth_name),
            'phoneNo':str(i.phoneNo),
            'Email':str(i.Email),
            'photo':str(i.photo.url),
            'position':str(i.position),
            'dob':str(i.dob),
            'gender':str(i.gender),
        }
        mdata.append(data)
    return JsonResponse({'status':'ok','data':mdata})


def UserViewOwnReports(request):
    ob=Report_table.objects.filter(user__Login__id=request.POST['lid'])
    mdata=[]
    for i in ob:
        data={
            'id':i.id,
            'auth_name':i.Authority.auth_name,
            'Date':i.Date,
            'report_type':i.report_type,
            'Audio':i.Audio.url,
            'latitude':i.latitude,
            'longitude':i.longitude,
            'status':i.status,
        }
        mdata.append(data)
    return JsonResponse({'status':'ok','data':mdata})

def UserViewAwarness(request):
    ob=Awareness_table.objects.all()
    mdata=[]
    for i in ob:
        data={
            'id':i.id,
            'added_by':i.authority.auth_name,
            'title':i.title,
            'file':i.file.url,
            'description':i.description,
            'punishment':i.punishment,
            'date':i.date,
        }
        mdata.append(data)
    return JsonResponse({'status':'ok','data':mdata})

def UserViewComplaintResponse(request):
    ob=complaint.objects.filter(USER__Login__id=request.POST['lid'])
    mdata=[]
    for i in ob:
        data={
            'id':i.id,
            'auth_name':i.authority.auth_name,
            'Date':i.Date,
            'complaint':i.complaint,
            'reply':i.reply,
        }
        mdata.append(data)
    return JsonResponse({'status':'ok','data':mdata})

def UserViewAuthorityFeedback(request):
    aid=request.POST['aid']
    ob=Feedback.objects.filter(authority_id=aid)
    mdata=[]
    for i in ob:
        data={
            'id':i.id,
            'USER':i.USER.name,
            'USER_photo':i.photo.url,
            'feedback':i.feedback,
            'rating':i.rating,
            'date':i.date,
        }
        mdata.append(data)
    return JsonResponse({'status':'ok','data':mdata})



import datetime

from datetime import datetime


def add_incident_report(request):
    if request.method == 'POST':
        try:
            # Capturing text and coordinate data
            lid = request.POST.get('lid')  # Login ID of the user
            auth_id = request.POST.get('authority_id')
            report_type = request.POST.get('report_type')
            lat = request.POST.get('latitude')
            lon = request.POST.get('longitude')

            # Capturing the physical audio file
            audio_file = request.FILES.get('Audio')

            # Initializing the model object
            ob = Report_table()

            # Linking Foreign Keys
            # We fetch the user profile based on the Login ID (lid)
            ob.user = userProfile.objects.get(Login__id=lid)
            ob.Authority = Authority_table.objects.get(id=auth_id)

            # Assigning other values
            ob.Date = datetime.today()
            ob.report_type = report_type
            ob.Audio = audio_file
            ob.latitude = float(lat)
            ob.longitude = float(lon)
            ob.status = 'pending'  # Default status for new incidents

            ob.save()

            return JsonResponse({'status': 'ok', 'message': 'Incident logged successfully'})

        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)})

    return JsonResponse({'status': 'error', 'message': 'Invalid request method'})
def get_audio(file):
    import speech_recognition as sr
    r = sr.Recognizer()

    with sr.AudioFile(file) as source:
        audio = r.record(source)
    try:
        s = r.recognize_google(audio)
        print("Text: " + s)
        return s
    except Exception as e:
        print("Exception: " + str(e))
        return "na"
from .textcomparison import detect_txt_type

def audioupload(request):

    if request.method == "POST":

        lid = request.POST.get("lid")
        audio_file = request.FILES['file']
        fs=FileSystemStorage()
        fn=fs.save(audio_file.name,audio_file)
        if fn.split(".")[-1].lower()=="wav":

            txt=get_audio(r"C:\Users\user\PycharmProjects\detecths\media/"+fn)
        else:
            import subprocess

            input_file = r"C:\Users\user\PycharmProjects\detecths\media/"+fn
            fn=fn.split(".")[0]+".wav"
            output_file = r"C:\Users\user\PycharmProjects\detecths\media/"+fn
            print(input_file,output_file)

            subprocess.call(['ffmpeg', '-i', input_file, output_file])

            txt = get_audio(output_file)



        result,confidence = detect_txt_type(txt)
        print(result)

        if result == '1':
            report=txt
        else:
            report='No Hate Speech Detected'
        # Save complaint
        Report_table.objects.create(
            user=userProfile.objects.get(Login_id=lid),
            Authority=Authority_table.objects.first(),
            report_type=report,
            Audio=audio_file,
            Date=datetime.today(),
            latitude=request.POST['latitude'],
            longitude=request.POST['longitude'],
            status='pending'
        )

        return JsonResponse({
            "status": "ok",
            "result": result,
            "confidence": confidence
        })

    return JsonResponse({"status": "no"})


def UserViewReportHistory(request):
    lid=request.POST['lid']

    a = Report_table.objects.filter(user__Login__id=lid)
    l = []
    for i in a:
        l.append({"id": str(i.id),
                  "status": i.status,
                  "Date": i.Date,
                  "authority": i.Authority.auth_name,
                  "Detected": i.report_type,
                  "Audio": i.Audio.url,
                  "loc": "http://maps.google.com?q="+str(i.latitude)+","+str(i.longitude),
                  })
    return JsonResponse({"status":"ok","data":l})
