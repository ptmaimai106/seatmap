
<div style="margin:2%">
    <span style="margin-right: 1%">
        <a href="/seatmap" style="text-decoration: none; font-weight: bold;">
           Home >
        </a>
    </span>
    {$count =0}
    {$numItem = count($breadcrumbs)}

    {foreach $breadcrumbs as $title => $link}
        {if $count== $numItem -1}
            <span style="margin-right: 1%">
                <a style="text-decoration: none;font-weight: bold;">
                    {$title}
                </a>
            </span>
            {else}
            <span style="margin-right: 1%">
                <a href="{$link}" style="text-decoration: none;font-weight: bold;">
                   {$title} >
                </a>
             </span>
        {/if}
    {$count = $count +1}
    {/foreach}
</div>
<hr/>
