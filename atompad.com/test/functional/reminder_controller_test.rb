require File.dirname(__FILE__) + '/../test_helper'
require 'reminder_controller'

# Re-raise errors caught by the controller.
class ReminderController; def rescue_action(e) raise e end; end

class ReminderControllerTest < Test::Unit::TestCase
  fixtures :reminders

  def setup
    @controller = ReminderController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = reminders(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:reminders)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:reminder)
    assert assigns(:reminder).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:reminder)
  end

  def test_create
    num_reminders = Reminder.count

    post :create, :reminder => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_reminders + 1, Reminder.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:reminder)
    assert assigns(:reminder).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Reminder.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Reminder.find(@first_id)
    }
  end
end
