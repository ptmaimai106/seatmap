{include file="share/header.tpl"}
{include file="share/breadcrumb.tpl"}

<div class="container" style="min-height: 60vh">
    {if $message}
        <p  class="alert alert-success" role="alert">{$message}</p>
    {/if}
    <div class="table-wrapper">
        <a href="#addSeatmap" class="btn btn-success" data-toggle="modal"><i class="material-icons">&#xE147;</i>
            <span>Add Seat-map</span>
        </a>
        {if sizeof($seatmapList) > 0}
        <table class="table table-striped table-hover">
            <thead>
            <tr>
                <th>NO</th>
                <th>NAME</th>
                <th>FILENAME</th>
                <th>CREATE AT</th>
                <th>UPDATE AT</th>

            </tr>
            </thead>
            <tbody>
            {for $i=0 to sizeof($seatmapList) -1}
                <tr id="{$seatmapList[$i]->id}">
                    <td>{$i +1}</td>
                    <td>
                        <a href="/seatmap/seatmaps/{$seatmapList[$i]->id}">
                            {$seatmapList[$i]->name}
                        </a>
                    </td>
                    <td>{$seatmapList[$i]->filename}</td>
                    <td>{$seatmapList[$i]->create_at}</td>
                    <td>{$seatmapList[$i]->update_at}</td>
                    <td>
                        <a  href="#editSeatmap"  class="edit" data-toggle="modal" >
                            <i class="material-icons update"
                               data-toggle="tooltip"
                               data-id="{$seatmapList[$i]->id}"
                               data-name="{$seatmapList[$i]->name}"
                               data-filename="{$seatmapList[$i]->filename}"
                               title="Edit">&#xE254;
                            </i>
                        </a>
                        <a href="#deleteSeatmap"
                           class="delete"
                           data-id="{$seatmapList[$i]->id}"
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
            <img src="uploads/not-found.png" alt="not-found">
        {/if}
    </div>

</div>

<div id="addSeatmap" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="seatmap_form" action="/seatmap/seatmaps" method="post" enctype="multipart/form-data">
                <div class="modal-header">
                    <h4 class="modal-title">Add Seat-map</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>NAME</label>
                        <input type="text" id="seatmap-name" name="name" class="form-control" required>
                    </div>
                    <div class="form-group" id="filename_add">
                        <label>FILENAME</label>
                        <input type="file" id="avatar" name="image" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="hidden" value="1" name="type">
                    <input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
                    <button type="submit" class="btn btn-success" id="btn-add" name="add-seatmap">Add</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="editSeatmap" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="update_form" action="/seatmap/seatmaps" method="post" enctype="multipart/form-data">
                <div class="modal-header">
                    <h4 class="modal-title">Edit Seat-map</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="id_u" name="id" class="form-control" required>
                    <div class="form-group">
                        <label>NAME</label>
                        <input type="text" id="name_u" name="name" class="form-control" required>
                    </div>
                    <div>
                        <img id="preview_u" style="width: 70px; height: 60px; border-radius: 50%" />
                    </div>

                    <div class="form-group">
                        <label>FILENAME</label>
                        <input type="file" id="filename_u" name="image" >
                        <input type="hidden" id="filename_old" name="image_seatmap" >
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
                    <button type="submit" class="btn btn-info" name="update-seatmap">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="deleteSeatmap" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="/seatmap/seatmaps" method="post">
                <div class="modal-header">
                    <h4 class="modal-title">Delete Seat-map</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="id_d" name="id_d" class="form-control">
                    <p>Are you sure you want to delete?</p>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
                    <button type="submit" class="btn btn-danger" id="delete-seatmap" name="delete-seatmap">Delete</button>
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
        const name = $(this).attr("data-name");
        const filename = $(this).attr("data-filename");

        $('#id_u').val(id);
        $('#name_u').val(name);
        $('#preview_u').attr('src', "/seatmap/controller/"+filename);
        $('#filename_old').val(filename);

    });

    $('#filename_u').change(function(e){
        const selectedFile = e.target.files[0];
        $('#preview_u').attr('src', URL.createObjectURL(selectedFile));
    });

    $('#avatar').change(function(e){
        const selectedFile = e.target.files[0];
        $('div#filename_add > img').remove();

        $("#filename_add").append("<img id='preview_a'  style=\"width: 70px; height: 60px; margin-top: 10px; border-radius: 50%\" />");
        $('#preview_a').attr('src', URL.createObjectURL(selectedFile));
    });
</script>