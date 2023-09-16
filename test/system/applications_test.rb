require "application_system_test_case"

class ApplicationsTest < ApplicationSystemTestCase
  setup do
    @application = applications(:one)
  end

  test "visiting the index" do
    visit applications_url
    assert_selector "h1", text: "Applications"
  end

  test "should create application" do
    visit applications_url
    click_on "New application"

    fill_in "Applied at", with: @application.applied_at
    fill_in "Archived at", with: @application.archived_at
    fill_in "Company link", with: @application.company_link
    fill_in "Details", with: @application.details
    check "Favorite" if @application.favorite
    fill_in "Job", with: @application.job_id
    fill_in "Job link", with: @application.job_link
    fill_in "Job source", with: @application.job_source
    fill_in "Notes", with: @application.notes
    fill_in "Rating", with: @application.rating
    fill_in "Stage", with: @application.stage
    fill_in "Status", with: @application.status
    fill_in "User", with: @application.user_id
    click_on "Create Application"

    assert_text "Application was successfully created"
    click_on "Back"
  end

  test "should update Application" do
    visit application_url(@application)
    click_on "Edit this application", match: :first

    fill_in "Applied at", with: @application.applied_at
    fill_in "Archived at", with: @application.archived_at
    fill_in "Company link", with: @application.company_link
    fill_in "Details", with: @application.details
    check "Favorite" if @application.favorite
    fill_in "Job", with: @application.job_id
    fill_in "Job link", with: @application.job_link
    fill_in "Job source", with: @application.job_source
    fill_in "Notes", with: @application.notes
    fill_in "Rating", with: @application.rating
    fill_in "Stage", with: @application.stage
    fill_in "Status", with: @application.status
    fill_in "User", with: @application.user_id
    click_on "Update Application"

    assert_text "Application was successfully updated"
    click_on "Back"
  end

  test "should destroy Application" do
    visit application_url(@application)
    click_on "Destroy this application", match: :first

    assert_text "Application was successfully destroyed"
  end
end
