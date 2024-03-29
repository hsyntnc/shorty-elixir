defmodule Shorty.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :shortcode, :string
    field :url, :string
    field :redirect_count, :integer, default: 0
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:shortcode, :url, :redirect_count])
    |> set_shortcode
    |> validate_required([:shortcode, :url])
    |> validate_shortcode
    |> validate_url
    |> unique_constraint(:shortcode)
  end

  @doc false
  defp set_shortcode(changeset) do
    if is_nil(get_field(changeset, :shortcode)) do
      changeset
      |> put_change(:shortcode, random_string(6))
    else
      changeset
    end

    # I've tried to make it without an if block but could't make it work.
    # All the advices are welcome for this function.
    # It says when we call get_field function, it returns the current value or
    # we can set a default value as a second parameter if its nil on official documentation but didnt work here.
    # I've spent like an hour here. I'll leave the old code here anyway.
    #
    # shortcode =
    #  changeset
    #  |> get_field(:shortcode, random_string(6))

    # changeset
    # |> put_change(:shortcode, shortcode)
  end

  @doc false
  defp validate_shortcode(changeset) do
    changeset
    |> validate_format(:shortcode, ~r/^[0-9a-zA-Z_]{6}$/)
  end

  @doc false
  defp validate_url(changeset) do
    changeset
    |> validate_format(:url, ~r/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/)
  end

  @doc false
  defp random_string(length) do
    chars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_1234567890"
      |> String.split("")
      |> Enum.filter(fn x ->
        x != ""
      end)

    Enum.map(1..length, fn _ -> Enum.random(chars) end) |> Enum.join("")
  end
end
