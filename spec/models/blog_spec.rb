require 'rails_helper'

RSpec.describe BlogPost, type: :model, vcr: true do
  let(:blog_post) { BlogPost.find_by(slug: 'some-blog-post').load.first }
  
  context 'when author is a team member' do
    
    before { stub_api_response('blog_post/with_a_team_member', 'fields.slug' => 'some-blog-post') }
    
    it 'it has an author' do
      expect(blog_post.author).to be_a(TeamMember)
    end
    
  end
  
  context 'when author is a board member' do
    
    before { stub_api_response('blog_post/with_a_board_member', 'fields.slug' => 'some-blog-post') }
    
    it 'it has an author' do
      expect(blog_post.author).to be_a(BoardMember)
    end
    
  end
  
end
