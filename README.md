1. ## Create new application  

`$ rails new wordkeep --database=postgresql -T`  

`$ rails g controller Words index new show`  

2. ## Allow app to create new Words  

_wordkeep/app/controllers/words_controller.rb_  

```
before_action :set_word, only: [:show]

def index  
  @words = Word.all  
end  

def new  
  @word = Word.new  
end  

def create  
  @word = Word.new(secure_params)  
    if @word.save  
      flash[:notice] = "Successfully created new word"  
      redirect_to projects_path  
    else
      flash[:notice] = "Unable to create new word"  
      render :new  
    end  
end  

#### At the bottom of all your other methods add:  

private

def secure_params
  params.require(:word).permit(:title)
end  

def set_word  
  @word = Word.find(params[:id])
end  
```  

3. ## Update routes  

_wordkeep/config/routes.rb_  

`resources :words`  

4. ## Generate Words & Definitions Model

```
$ rails g model Words title:string  

$ rails g model Definitions body:text word_id:integer  

$ rails db:create:all  

$ rails db:migrate  
```  

5. ## Add db associations to Words & Definitions Model  

_wordkeep/app/models/word.rb_  

```
has_many :definitions, dependent: :destroy, inverse_of: :word  
accepts_nested_attributes_for :definitions, reject_if: proc { |attributes| attributes[:body].blank?}  
```
_wordkeep/app/models/definition.rb_  

```
	belongs_to :word, inverse_of: :definitions  
```

6. ## Update Controller for accepts_nested_attributes_for  

_wordkeep/app/controllers/words_controller.rb_  

```
def new  
  @word = Word.new  
  @word.definitions.build  
end  

def secure_params  
  params.require(:word).permit(:title, definitions_attributes: [:id, :body])  
end  
```  

7. ## Fill in the views  

_wordkeep/app/views/words/new.html.erb_  

```
<h2>Create a new Word</h2>  
  <%= form_for @word do |w| %>  
  <%= w.label :title %>  
  <%= w.text_field :title %>  
    <%= w.fields_for :definitions do |d| %>  
    <%= d.label :body %>  
    <%= d.text_area :body, size: "30x10" %>  
    <% end %>  
  <%= w.submit 'Create Word' %>  
<% end %>  
```  
  
_wordkeep/app/views/words/index.html.erb_  

```
<h1>View all Words:</h1>  

<% for word in @words %>  
<h4><%= project.title %></h4>  
  <% for definition in word.definitions %>  
  <p><%= definition.body %></p>  
  <% end %>  
<% end %>  
```  

_wordkeep/app/views/words/show.html/erb_  

```
<h4><%= @word.title %></h4>  
<% for definition in @word.definitions %>  
  <p><%= definition.body %></p>  
<% end %>  
```
8. ## Additional controller functionality  

_wordkeep/app/controllers/words_controller.rb_  

```
before_action :set_word, only: [:show, :edit, :update, :destroy]  

def edit  
end  

def update  
  if @word.update_attributes(secure_params)  
    redirect_to @word, notice: 'Successfully updated word'  
  else  
    render :edit  
  end  
end  

def destroy  
  @word.destroy  
  redirect_to words_path  
end  
```  

9. ## Add fields_for to edit form  

_wordkeep/app/views/words/edit.hrml.erb_  

```
<h2>Edit Word:</h2>  
<%= form_for @word do |w| %>  
<%= w.label :title %>  
<%= w.text_field :title %>  
  <%= w.fields_for :definitions do |d| %>  
    <%= d.label :body %>  
    <%= d.text_field :body %>  
  <% end %>  
  <%= w.submit "Update" %>  
<% end %>  
```   

10. ## Add navigational links  

_wordkeep/app/views/words/index.hrml.erb_  

```
<h1>View all Words:</h1>  

<%= for word in @words %>  
  <h4><%= word.title %></h4>  
  <%= for definition in word.definitions %>  
    <p><%= definition.body %></p>  
  <% end %>  
  <li><%= link_to "View", word_path(word.id) %></li>  
  <li><%= link_to "Update", word_path(word.id) %></li>  
  <li><%= link_to "Delete", word_path(word.id), method: :delete, data: {confirm: 'Are you sure?'}%></li>  
<% end %>  

<li><%= link_to "Create new word", new_word_path %></li>  

```  

_wordkeep/app/views/words/show.html.erb_  

```
#### add these lines to the bottom  
<li><%= link_to "View all Words", words_path %></li>  
<li><%= link_to "Edit this Word", edit_word_path(@word) %></li>  
```  

_wordkeep/app/views/words/edit.html.erb_  

```
#### add these lines to the bottom  
<li><%= link_to "View all Words", words_path %></li>  
<li><%= link_to "View this Word", word_path(@word) %></li>  
```  

_wordkeep/app/views/words/index.hrml.erb_  

```
#### add this line to the bottom	  
<li><%= link_to "View all Words", words_path %></li>  
```  


`$ rails db:migrate`  

`$ rails s`  


#### At this point you have a functioning application structure that can add words with definitions