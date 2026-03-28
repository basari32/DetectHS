# Source - https://stackoverflow.com/q/54916400
# Posted by Bojack
# Retrieved 2026-03-13, License - CC BY-SA 4.0
def speech_to_text(path):
    import speech_recognition as sr
    r = sr.Recognizer()

    with sr.AudioFile(r"C:\Users\user\PycharmProjects\detecths\media\idling.2qsie33u.ingestion-5b6b8dfb4f-cqq49.wav") as source:
        audio = r.record(source)
    try:
        s = r.recognize_google(audio)
        print("Text: "+s)
    except Exception as e:
        print("Exception: "+str(e))
