{include file="share/header.tpl"}
{include file="share/breadcrumb.tpl"}

<div class="container" style="min-height: 60vh">
    <div class="row mt-3 mb-5">
        <p class="col-4 col-md-4">Seat-map list : </p>
        <select class="custom-select col-6 col-md-6" name="seatmapList" >
            {while $row = $seatmapList->fetch_assoc()}
                {if $row['id'] == $seatmap["id"]}
                <option value="{$row['id']}" selected>
                    <a href="/seatmap/seatmaps?id={$row["id"]}"> {$row['name']}</a>
                </option>
                {else}
                    <option value="{$row['id']}" >
                        <a href="/seatmap/seatmaps/{$row["id"]}"> {$row['name']}</a>
                    </option>
                {/if}
            {/while}
        </select>
    </div>
    <hr/>
    <div style="font-size: 11px; text-align: center">
        <p>Drag each user from User list to seat-map to set user's position</p>
        <p>Drag and drop user in current seatmap to change user's position</p>
    </div>

    <div class="mt-3 row seat-map" >
        <div class="col-3 col-md-3">
            <p>User list: </p>
            <div
                class="userList"
                style="
                    height: 60vh;
                    overflow-y: scroll;
                    overflow-x:hidden;">
                {while $row = $userList->fetch_assoc()}
                    <div class="userItem" id="{$row['id']}" style="width: 100px">
                        <img src="/seatmap/controller/{$row['avatar']}" width="50" height="50" style="display: inline; border-radius: 50%"/>
                        <p style="display: inline">{$row['username']}</p>
                    </div>
                {/while}
            </div>
        </div>

        <div class="col-9 col-md-9" id="seatmap" style="height: 60vh;
                                                        border: #d3d3d3 1px solid;
                                                        border-radius: 10px;
                                                        margin-top: 5%;
                                                        background-image: url('/seatmap/controller/{$seatmap['filename']}')">
            {while $row = $hasPositionUsers->fetch_assoc()}
                <div class="userItem" id="{$row['id_user']}" style="
                        position: absolute;
                        padding: 2px;
                        top: {$row['coordinate_y']}px;
                        left: {$row['coordinate_x']}px;
                        width: 90px; border-radius: 20px;
                        border: 1px solid gray;
                        text-align: center;
                        box-shadow:  0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);"
                >
                    <button type="button" class="close" >&times;</button>
                    <img src="/seatmap/controller/{$row['avatar']}" width="50" height="50" style="display: inline; border-radius: 50%"/>
                    <p style="display: inline">{$row['username']}</p>

                </div>
            {/while}
        </div>

    </div>

</div>

{include file="share/footer.tpl"}

<script>
    $("select[name=seatmapList]").change(function() {
        const id = $(this).val();
        location.href="/seatmap/seatmaps/"+id;
    });

    $(".userItem").draggable({
        scroll: false,
        containment: ".seat-map",
    });

    $("#seatmap").droppable({
        accept: ".userItem",
        drop: function(ev, ui)
        {
            const userPosition = ui.position;
            const coordinate_x =  userPosition.left;
            const coordinate_y =  userPosition.top;
            const id_seatmap = $("select[name=seatmapList]").val();

            const element =  document.getElementById(ui.draggable.context.id);
            if(! element.querySelector(".close")){
                $(ui.draggable).prepend("<button type='button' class='close' >&times;</button>");
            }
            $(ui.draggable).appendTo($(this)).css({
                'left':coordinate_x ,
                'top': coordinate_y,
                'position': 'absolute',
                'padding': '2px',
                'width': '90px',
                'border-radius': '20px',
            'border': '1px solid gray',
            'text-align': 'center',
            'box-shadow':  '0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19)'
            })

            const xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    // location.href="/seatmap/seatmaps/"+id_seatmap;
                }
            };
            xmlhttp.open("POST", "../controller/user_seatmap_controller.php", true);
            xmlhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

            const data = "seatmap="+id_seatmap+"&&user="+ ui.draggable.context.id+ "&&x="+coordinate_x+"&&y="+coordinate_y;
            xmlhttp.send(data);
        },

        out: function (ev, ui){
            const id_seatmap = $("select[name=seatmapList]").val();
            location.href="/seatmap/seatmaps/"+id_seatmap;
        },

    });

    $(".close").click(function (){

        const id_seatmap = $("select[name=seatmapList]").val();
        const id_user=$(this).closest('div').attr('id');

        const xmlhttp = new XMLHttpRequest();
        xmlhttp.open("POST", "../controller/user_seatmap_controller.php", true);
        xmlhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                  location.href="/seatmap/seatmaps/"+id_seatmap;
            }
        };
        const data = "remove=1&&seatmap="+id_seatmap+"&&user="+ id_user;
        xmlhttp.send(data);
    })

</script>