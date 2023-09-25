require "application_system_test_case"

class DocsTest < ApplicationSystemTestCase
  setup do
    @doc = docs(:one)
  end

  test "visiting the index" do
    visit docs_url
    assert_selector "h1", text: "Docs"
  end

  test "should create doc" do
    visit docs_url
    click_on "New doc"

    fill_in "Body", with: @doc.body
    check "Current" if @doc.current
    fill_in "Doc type", with: @doc.doc_type
    fill_in "Documentable", with: @doc.documentable_id
    fill_in "Documentable type", with: @doc.documentable_type
    fill_in "Name", with: @doc.name
    fill_in "Raw body", with: @doc.raw_body
    click_on "Create Doc"

    assert_text "Doc was successfully created"
    click_on "Back"
  end

  test "should update Doc" do
    visit doc_url(@doc)
    click_on "Edit this doc", match: :first

    fill_in "Body", with: @doc.body
    check "Current" if @doc.current
    fill_in "Doc type", with: @doc.doc_type
    fill_in "Documentable", with: @doc.documentable_id
    fill_in "Documentable type", with: @doc.documentable_type
    fill_in "Name", with: @doc.name
    fill_in "Raw body", with: @doc.raw_body
    click_on "Update Doc"

    assert_text "Doc was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc" do
    visit doc_url(@doc)
    click_on "Destroy this doc", match: :first

    assert_text "Doc was successfully destroyed"
  end
end
