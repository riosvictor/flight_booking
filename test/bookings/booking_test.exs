defmodule Flightex.Bookings.BookingTest do
  use ExUnit.Case, async: false

  alias Flightex.Bookings.Booking

  describe "build/4" do
    test "when all params are valid, returns a booking" do
      {:ok, response} =
        Booking.build(
          # ~N[2001-05-07 01:46:20],
          "07/05/2001 01:46:20",
          "Brasilia",
          "ilha das bananas",
          "12345678900"
        )

      expected_response = %Flightex.Bookings.Booking{
        complete_date: ~N[2001-05-07 01:46:20],
        id: response.id,
        local_destination: "ilha das bananas",
        local_origin: "Brasilia",
        user_id: "12345678900"
      }

      assert response == expected_response
    end

    test "when date param is invalid, returns an error" do
      response =
        Booking.build(
          "07/05/200101:46:20",
          "Brasilia",
          "ilha das bananas",
          "12345678900"
        )

      expected_response = {:error, "Invalid date format"}

      assert response == expected_response
    end
  end
end
