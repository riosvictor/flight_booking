defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        # complete_date: ~N[2001-05-07 12:00:00],
        complete_date: "07/05/2001 12:00:00",
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900"
      }

      content = "Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Report.generate("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end

  describe "generate/3" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called out from offset, return the empty content" do
      params = %{
        # complete_date: ~N[2001-05-07 12:00:00],
        complete_date: "07/05/2001 12:00:00",
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900"
      }

      Flightex.create_or_update_booking(params)
      Flightex.create_or_update_booking(params)
      Flightex.create_or_update_booking(params)

      content = ""

      Report.generate("report-test.csv", ~N[2001-05-08 12:00:00], ~N[2001-05-09 12:00:00])
      {:ok, file} = File.read("report-test.csv")

      assert file == content
    end

    test "when called in offset, return the full content" do
      params = %{
        # complete_date: ~N[2001-05-07 12:00:00],
        complete_date: "07/05/2001 12:00:00",
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900"
      }

      Flightex.create_or_update_booking(params)
      Flightex.create_or_update_booking(params)
      Flightex.create_or_update_booking(params)

      Report.generate("report-test.csv", ~N[2001-05-06 12:00:00], ~N[2001-05-08 12:00:00])
      {:ok, file} = File.read("report-test.csv")

      count_lines =
        file
        |> String.trim()
        |> String.split("\n")
        |> length()

      expected_count_lines = 3

      assert count_lines == expected_count_lines
    end
  end
end
