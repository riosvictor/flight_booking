defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Bookings.Booking

  def generate(filename \\ "report.csv") do
    flight_list = build_flight_list()

    File.write("#{filename}", flight_list)
  end

  def generate(filename \\ "report.csv", from_date, to_date) do
    flight_list = build_flight_list(from_date, to_date)

    File.write("#{filename}", flight_list)
  end

  defp build_flight_list() do
    BookingsAgent.list_all()
    |> Map.values()
    |> Enum.map(fn order -> booking_string(order) end)

    # |> Enum.map(&booking_string(&1))
  end

  defp build_flight_list(from, to) do
    BookingsAgent.list_all()
    |> Map.values()
    |> Enum.filter(fn booking ->
      NaiveDateTime.compare(booking.complete_date, from) in [:gt, :eq] and
        NaiveDateTime.compare(booking.complete_date, to) in [:lt, :eq]
    end)
    |> Enum.map(fn booking -> booking_string(booking) end)

    # |> Enum.map(&booking_string(&1))
  end

  defp booking_string(%Booking{
         complete_date: date,
         local_origin: origin,
         local_destination: destination,
         id: id
       }) do
    "#{id},#{origin},#{destination},#{NaiveDateTime.to_string(date)}\n"
  end
end
