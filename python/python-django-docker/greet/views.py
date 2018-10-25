from django.http import JsonResponse


def hello(request):
    who = request.GET.get('who', 'World')
    return JsonResponse({'data': {'greeting': f'Hello, {who}!'}})
