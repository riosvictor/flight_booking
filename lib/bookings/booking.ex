defmodule Flightex.Bookings.Booking do
  @keys [:complete_date, :local_origin, :local_destination, :user_id, :id]
  @enforce_keys @keys

  defstruct @keys

  # complete_date format = dd/mm/yyyy hh:mm:ss
  def build(complete_date, local_origin, local_destination, user_id) do
    with {:ok, naive_date} <- get_naive_date(complete_date) do
      uuid = UUID.uuid4()

      {:ok,
       %__MODULE__{
         complete_date: naive_date,
         local_origin: local_origin,
         local_destination: local_destination,
         user_id: user_id,
         id: uuid
       }}
    else
      error -> error
    end
  end

  defp get_naive_date(string_date) do
    with {:ok, array_datetime} <- get_array_info_date(string_date),
         {:ok, array_details_datetime} <- get_values_datetime(array_datetime) do
      [day, month, year, hour, minute, second] = array_details_datetime
      NaiveDateTime.new(year, month, day, hour, minute, second)
    else
      error -> error
    end
  end

  defp get_array_info_date(string_date) do
    result = String.split(string_date)

    if length(result) == 2, do: {:ok, result}, else: {:error, "Invalid date format"}
  end

  defp get_values_datetime(array_datetime) do
    [date, time] = array_datetime

    detail_date = String.split(date, "/")
    detail_time = String.split(time, ":")

    if length(detail_date) == 3 and length(detail_time) == 3 do
      values =
        (detail_date ++ detail_time)
        |> Enum.map(&String.to_integer/1)

      {:ok, values}
    else
      {:error, "Invalid date format"}
    end
  end
end
