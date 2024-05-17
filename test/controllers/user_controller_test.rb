require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  test "successful cash in" do
    user = users(:one)  # Assuming there's a user with id 1 in the fixtures
    amount = 100.00  # A positive amount to be added to the user's balance

    # Simulate a POST request to update the user's balance
    post user_update_balance_path(user_id: user.id), params: { cash_in_amount: amount.to_s }

    # Assert that the user's balance has been updated
    assert_equal amount, User.find(user.id).default_balance

    # Assert that a success message is displayed
    assert_equal "Successfully added $#{'%.2f' % amount} to your balance.", flash[:notice]
  end

  test "invalid cash in amount" do
    user = users(:one)
    amount = 0.00  # A non-positive amount

    # Simulate a POST request to update the user's balance
    post user_update_balance_path(user_id: user.id), params: { cash_in_amount: amount.to_s }

    # Assert that the user's balance has not been updated
    assert_not_equal amount, User.find(user.id).default_balance

    # Assert that an error message is displayed
    assert_equal "Please enter a valid cash in amount (positive number).", flash[:error]
  end

  test "cash in with negative amount" do
    user = users(:one)
    amount = -100.00  # A negative amount

    # Simulate a POST request to update the user's balance
    post user_update_balance_path(user_id: user.id), params: { cash_in_amount: amount.to_s }

    # Assert that the user's balance has not been updated
    assert_not_equal amount, User.find(user.id).default_balance

    # Assert that an error message is displayed
    assert_equal "Please enter a valid cash in amount (positive number).", flash[:error]
  end

  test "cash in with zero amount" do
    user = users(:one)
    amount = 0.00  # A zero amount

    # Simulate a POST request to update the user's balance
    post user_update_balance_path(user_id: user.id), params: { cash_in_amount: amount.to_s }

    # Assert that the user's balance has not been updated
    assert_not_equal amount, User.find(user.id).default_balance

    # Assert that an error message is displayed
    assert_equal "Please enter a valid cash in amount (positive number).", flash[:error]
  end

  test "cash in with non-numeric amount" do
    user = users(:one)
    amount = "abc"  # A non-numeric amount

    # Simulate a POST request to update the user's balance
    post user_update_balance_path(user_id: user.id), params: { cash_in_amount: amount }

    # Assert that the user's balance has not been updated
    assert_not_equal amount, User.find(user.id).default_balance

    # Assert that an error message is displayed
    assert_equal "Please enter a valid cash in amount (positive number).", flash[:error]
  end
end
