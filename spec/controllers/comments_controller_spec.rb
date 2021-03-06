require 'rails_helper'
require 'features/steps/contentful_steps'

RSpec.describe CommentsController, type: :controller, vcr: true, contentful: true, preview: true do
  include ContentfulSteps
  
  let(:params) do
    {
      blog_post_id: 'wanted-pioneer-partners-for-the-what-works-centre',
      comment: {
        name: 'Some Person',
        email: 'foo@bar.com',
        organisation: 'Some Organisation',
        comment: 'Great stuff!'
      }
    }
  end
  let(:blog_post) { create_blog_post(params[:blog_post_id]) }
  
  describe '#create' do
    let(:subject) { post :create, params: params }
    let(:comment) { Comment.preview.all.load.last }
        
    it 'creates a comment for a blog post' do
      expect { subject }.to change { Comment.preview.all.load.count }.by(1)
    end
    
    it 'creates the correct fields' do
      subject
      expect(comment.name).to eq(params[:comment][:name])
      expect(comment.email).to eq(params[:comment][:email])
      expect(comment.organisation).to eq(params[:comment][:organisation])
      expect(comment.comment).to eq(params[:comment][:comment])
      expect(comment.associated_record.slug).to eq(blog_post.slug)
    end
    
  end
  
  describe '#publish' do
    let(:comment) { Comment.create(params[:comment].merge(associated_record: blog_post)) }
    let(:subject) { get :publish, params: { id: comment.id } }
    
    it 'publishes a comment' do
      subject
      expect(Comment.find_by(id: comment.id).load.count).to eq(1)
    end
    
  end
  
end
