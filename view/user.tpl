
{include file="share/header.tpl"}

{include file="share/breadcrumb.tpl"}
<div class="container" style="min-height: 60vh">
    {if $message}
         <p  class="alert alert-success" role="alert">{$message}</p>
    {/if}
    <div class="table-wrapper">
        <a href="#addUserModal" class="btn btn-success" data-toggle="modal"><i class="material-icons">&#xE147;</i>
            <span>Add New User</span>
        </a>
        {if sizeof($userList) >0}
            <table class="table table-striped table-hover">
                <thead>
                <tr>
                    <th>NO</th>
                    <th>USERNAME</th>
                    <th>EMAIL</th>
                    <th>AVATAR</th>
                    <th>STATUS</th>
                    <th>CREATE AT</th>
                    <th>UPDATE AT</th>
                </tr>
                </thead>

                <tbody>
                {for $i=0 to sizeof($userList) -1}
                    <tr id="{$userList[$i]->id}">
                        {if $page}
                            <td>{$i +1 + ($page-1)*10}</td>
                        {else}
                            <td>{$i +1}</td>
                        {/if}
                        <td>{$userList[$i]->username}</td>
                        <td>{$userList[$i]->email}</td>
                        <td>
                            <img src='/seatmap/controller/{$userList[$i]->avatar}' alt="avatar" style="width: 70px; height: 60px; border-radius: 50%;"
                        </td>
                        {if $userList[$i]->status == 'active'}
                            <td>
                                <i class="material-icons" data-toggle="tooltip" title="active">verified_user</i>
                            </td>
                        {else}
                            <td>
                                <i class="material-icons" data-toggle="tooltip" title="inactive">work_off</i>
                            </td>
                        {/if}
                        <td>{$userList[$i]->create_at}</td>

                        <td>{$userList[$i]->update_at}</td>

                        <td>
                            <a  href="#editUserModal"  class="edit" data-toggle="modal" >
                                <i class="material-icons update"
                                   data-toggle="tooltip"
                                   data-id="{$userList[$i]->id}"
                                   data-username="{$userList[$i]->username}"
                                   data-email="{$userList[$i]->email}"
                                   data-avatar="{$userList[$i]->avatar}"
                                   data-status="{$userList[$i]->status}"
                                   title="Edit">&#xE254;
                                </i>
                            </a>
                            <a href="#deleteUserModal"
                               class="delete"
                               data-id="{$userList[$i]->id}"
                               data-toggle="modal">
                                <i class="material-icons"
                                   data-toggle="tooltip"
                                   title="Delete">&#xE872;</i>
                            </a>
                        </td>
                    </tr>
                {/for}
                </tbody>
            </table>
        {else}
            <img src="/seatmap/controller/upload/not-found.png" alt="not-found">
        {/if}
        <hr/>
        {if $numPage > 1}
            <div>
                {for $i=1 to $numPage }
                    <a
                            href="/seatmap/users/{$i}"
                            style=" text-decoration: none;
                            padding: 8px 16px;
                            color: black;
                            float: left;">
                        {$i}
                    </a>
                {/for}
            </div>
        {/if}

    </div>
</div>

<div id="addUserModal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="user_form" action="/seatmap/users" method="post" enctype="multipart/form-data">
                <div class="modal-header">
                    <h4 class="modal-title">Add User</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>USERNAME</label>
                        <input type="text" id="username" name="username" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>EMAIL</label>
                        <input type="email" id="email" name="email" class="form-control" required>
                    </div>

                    <div class="form-group" id="preview_add">
                        <label>AVATAR</label>
                        <input type="file" id="avatar" name="image" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="hidden" value="1" name="type">
                    <input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
                    <button type="submit" class="btn btn-success add-user" id="btn-add" name="add-user">Add</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="editUserModal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="update_form" action="/seatmap/users" method="post" enctype="multipart/form-data">
                <div class="modal-header">
                    <h4 class="modal-title">Edit User</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="id_u" name="id" class="form-control" required>
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" id="username_u" name="username" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" id="email_u" name="email" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label>Status</label>
                        <div style="display: flex; justify-content: space-evenly">
                            <div>
                                <input type="radio" id="active" name="status" value="active">
                                <label for="active" style="font-weight: normal">Active</label>
                            </div>
                            <div>
                                <input type="radio" id="inactive" name="status" value="inactive">
                                <label for="inactive" style="font-weight: normal">InActive</label>
                            </div>
                        </div>


                    </div>

                    <div>
                        <img id="preview_u" style="width: 70px; height: 60px; border-radius: 50%" />
                    </div>

                    <div class="form-group" >
                        <label>Avatar</label>
                        <input type="file"  id="avastar_u" name="image" >
                        <input type="hidden"  id="avatar_old" name="avatar" >
                    </div>
                </div>

                <div class="modal-footer">
                    <input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
                    <button type="submit" class="btn btn-info" name="update-user">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="deleteUserModal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="/seatmap/users" method="post">
                <div class="modal-header">
                    <h4 class="modal-title">Delete User</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="id_d" name="id_d" class="form-control">
                    <p>Are you sure you want to delete?</p>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
                    <button type="submit" class="btn btn-danger" id="delete-user" name="delete-user">Delete</button>
                </div>
            </form>
        </div>
    </div>
</div>

{include file="share/footer.tpl"}

<script>
    $(document).on("click", ".delete", function () {
        const id = $(this).attr("data-id");
        $('#id_d').val(id);
    });

    $(document).on('click', '.update', function (e) {
        const id = $(this).attr("data-id");
        const username = $(this).attr("data-username");
        const email = $(this).attr("data-email");
        const avatar = $(this).attr("data-avatar");
        const status = $(this).attr("data-status");

        $('#id_u').val(id);
        $('#username_u').val(username);
        $('#email_u').val(email);
        $('#preview_u').attr('src', "/seatmap/controller/"+avatar);
        $('#avatar_old').val(avatar);
        $('#'+status).prop('checked', true);
    });

    $('#avatar_u').change(function(e){
        const selectedFile = e.target.files[0];
        $('#preview_u').attr('src', URL.createObjectURL(selectedFile));
    });

    $('#avatar').change(function(e){
        const selectedFile = e.target.files[0];
        $('div#preview_add > img').remove();

        $("#preview_add").append("<img id='preview_a'  style=\"width: 70px; height: 60px; margin-top: 10px; border-radius: 50%\" />");
        $('#preview_a').attr('src', URL.createObjectURL(selectedFile));
    });

</script>

