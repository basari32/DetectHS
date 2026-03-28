# from django.http import JsonResponse
# from django.views.decorators.csrf import csrf_exempt
# from django.core.cache import cache
# from sentence_transformers import SentenceTransformer, util
# import threading
#
# # Thread-safe model loading using a lock
# _model = None
# _model_lock = threading.Lock()
#
# def get_model():
#     """Lazy-load the model with thread safety."""
#     global _model
#     if _model is None:
#         with _model_lock:
#             if _model is None:  # Double-checked locking
#                 _model = SentenceTransformer('all-MiniLM-L6-v2')
#     return _model
#
#
# def calculate_similarity(student_answer: str, correct_answer: str) -> float:
#     """Calculate cosine similarity between two answers."""
#     model = get_model()
#     student_embedding = model.encode(student_answer, convert_to_tensor=True)
#     correct_embedding = model.encode(correct_answer, convert_to_tensor=True)
#     similarity = util.cos_sim(student_embedding, correct_embedding)
#     return float(similarity.item())
#
#
# def calculate_mark(similarity_score: float, max_mark: float) -> float:
#     """
#     Calculate mark from similarity score.
#     Clamps similarity to [0, 1] before multiplying to avoid negative marks.
#     """
#     clamped_score = max(0.0, min(1.0, similarity_score))
#     return round(clamped_score * max_mark, 2)
#
#
# @csrf_exempt  # Remove this if you handle CSRF via headers/middleware
# def savestudentanswer(request):
#     if request.method != 'POST':
#         return JsonResponse({"status": "error", "message": "Invalid request method"}, status=405)
#
#     try:
#         # --- Input Validation ---
#         question_id = request.POST.get('question_id')
#         student_id = request.POST.get('student_id')
#         selected_answer = request.POST.get('answer', '').strip()
#
#         if not all([question_id, student_id, selected_answer]):
#             return JsonResponse({
#                 "status": "error",
#                 "message": "Missing required fields: question_id, student_id, answer"
#             }, status=400)
#
#         if len(selected_answer) < 2:
#             return JsonResponse({
#                 "status": "error",
#                 "message": "Answer is too short"
#             }, status=400)
#
#         # --- Database Lookups ---
#         try:
#             question = question_table.objects.get(id=question_id)
#         except question_table.DoesNotExist:
#             return JsonResponse({"status": "error", "message": "Question not found"}, status=404)
#
#         try:
#             student = Student_table.objects.get(LOGIN_id=student_id)
#         except Student_table.DoesNotExist:
#             return JsonResponse({"status": "error", "message": "Student not found"}, status=404)
#
#         # --- Duplicate Check ---
#         if result_table.objects.filter(QUESTION=question, STUDENT=student).exists():
#             return JsonResponse({
#                 "status": "error",
#                 "message": "Answer already submitted"
#             }, status=409)
#
#         # --- Similarity Calculation ---
#         similarity_score = calculate_similarity(selected_answer, question.answer)
#         mark = calculate_mark(similarity_score, float(question.mark))
#
#         # --- Save Result ---
#         result_table.objects.create(
#             QUESTION=question,
#             STUDENT=student,
#             mark=mark
#         )
#
#         SIMILARITY_THRESHOLD = 0.7
#         return JsonResponse({
#             "status": "ok",
#             "message": "Answer saved",
#             "similarity": round(similarity_score, 4),
#             "mark": mark,
#             "max_mark": float(question.mark),
#             "correct": similarity_score >= SIMILARITY_THRESHOLD
#         }, status=201)
#
#     except Exception as e:
#         # Log the error in production instead of exposing it
#         # logger.exception("Unexpected error in savestudentanswer")
#         return JsonResponse({
#             "status": "error",
#             "message": "An internal error occurred"  # Don't expose str(e) in production
#         }, status=500)