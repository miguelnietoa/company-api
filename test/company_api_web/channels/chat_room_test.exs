defmodule CompanyApiWeb.ChatRoomTest do
  use CompanyApiWeb.ChannelCase
  alias CompanyApi.Guardian, as: Guard
  alias CompanyApiWeb.{ChatRoom, UserSocket, Conversation}

  @first_user_data %{name: "John", subname: "Doe", email: "doe@gmail.com", job: "engineer"}
  @second_user_data %{name: "Jane", subname: "Doe", email: "jane@gmail.com", job: "architect"}

  setup do
    user =
      %User{}
      |> User.reg_changeset(@first_user_data)
      |> Repo.insert!()

    {:ok, token, _claims} = Guard.encode_and_sign(user)
    {:ok, soc} = connect(UserSocket, %{"token" => token})
    {:ok, _, socket} = subscribe_and_join(soc, ChatRoom, "room:chat")
    {:ok, socket: socket, user: user}
  end

  test "checks messaging", %{socket: socket, user: u} do
    user =
      %User{}
      |> User.reg_changeset(@second_user_data)
      |> Repo.insert!()

    conv =
      %Conversation{}
      |> Conversation.changeset(%{sender_id: u.id, recipient_id: user.id})
      |> Repo.insert!()

    {:ok, token, _claims} = Guard.encode_and_sign(user)
    {:ok, soc} = connect(UserSocket, %{"token" => token})
    {:ok, _, socketz} = subscribe_and_join(soc, ChatRoom, "room:chat")
    push(socket, "send_msg", %{user: user.id, conv: conv.id, message: "Hi! This is message"})
    assert_push "receive_msg", %{message: message}
    assert message.content == "Hi! This is message"
    refute Repo.get!(CompanyApiWeb.Message, message.id) == nil
    push(socketz, "send_msg", %{user: u.id, conv: conv.id, message: "This is a reply"})
    assert_push "receive_msg", %{message: reply}
    assert reply.content == "This is a reply"
    refute Repo.get!(CompanyApiWeb.Message, reply.id) == nil
  end
end
