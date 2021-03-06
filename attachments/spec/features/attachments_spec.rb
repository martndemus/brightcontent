require 'spec_helper'

feature "Attachments" do
  background do
    sign_in
  end

  scenario "show message if item is not saved" do
    click_link "Blogs"
    click_link "Create new Blog"
    page.should have_content "First save to enable uploads"
  end

  scenario "show upload form" do
    create(:blog)
    click_link "Blogs"
    click_link "Edit"
    page.should have_selector "#attachments"
  end

  context "with image" do
    background do
      blog = create(:blog)
      @attachment = Brightcontent::Attachment.create!(:asset => Rails.root.join("public/rails.png").open)
      blog.attachments << @attachment
      click_link "Blogs"
      click_link "Edit"
    end

    scenario "shows images" do
      page.should have_selector "#attachment_#{@attachment.id}"
    end

    scenario "delete image" do
      within "#attachment_#{@attachment.id}" do
        click_link "Delete"
      end
      page.should_not have_selector "#attachment_#{@attachment.id}"
    end
  end
end
