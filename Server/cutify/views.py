
from django import forms
from django.views.generic import TemplateView, FormView
from portfolio.models import PortfolioEntry
from django.contrib import messages
from django.shortcuts import render_to_response, get_object_or_404, redirect
from contact.models import Contact

class ContactForm(forms.ModelForm):
    
    name = forms.CharField(required=False)
    email = forms.CharField(required=False)
    message = forms.CharField(widget=forms.Textarea, required=False)

    class Meta:
        model = Contact

class HomeView(TemplateView):
    
    template_name = 'home.html'

    def get_context_data(self, **kwargs):        
        # Call the base implementation first to get a context
        context = super(HomeView, self).get_context_data(**kwargs)
        # Add in the publisher
        context['portfolio'] = PortfolioEntry.published.all()
        context['contact_form'] = ContactForm(initial={'name': 'Name', 'email': 'E-mail Address', 'message': 'Message'})
        return context


class ContactView(FormView):
    
    form_class = ContactForm
    
    def form_valid(self, form):
        form = form.save()
        messages.success(self.request, "Thanks for contacting us. We'll get back to you in a jiffy!")
        return redirect('home')
