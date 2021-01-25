defmodule NervesHubWebCore.Repo.Migrations.AddFingerprintToDeviceCertificates do
  use Ecto.Migration

  alias NervesHubWebCore.{Devices, Devices.DeviceCertificate}

  import Ecto.Query

  def change do
    alter table(:device_certificates) do
      add :fingerprint, :string
      add :public_key_fingerprint, :string
    end

    create unique_index :device_certificates, :fingerprint
    create index :device_certificates, :public_key_fingerprint

    execute(&execute_up/0, &execute_down/0)
  end

  defp execute_up() do
    from(c in DeviceCertificate, where: not is_nil(c.der))
    |> repo().all()
    |> Enum.each(&Devices.update_device_certificate(&1, %{}))
  end

  defp execute_down(), do: :ok
end
