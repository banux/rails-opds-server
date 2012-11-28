popover_book_index_conf = {"placement":"top"};

$(document).ready(function() {
	$('.manage_catalog_book').popover(popover_book_index_conf);
});


$(document).ready(function() {
	$('.manage_catalog_book').click(function(env){
		env.preventDefault();
		var link_elem = $(this);
		var link = $(this).attr("href");	
		$.getJSON(link, function(data) {
			var action = data.action;
			var title = data.title;
			if(action == "ADD")
			{
				link_elem.text(title);
				link_elem.attr('href', link.replace('add', 'del'));
				link_elem.attr('data-content', data.popover_content);
				link_elem.removeClass("btn-success");
				link_elem.addClass("btn-danger");
				$('.manage_catalog_book').popover(popover_book_index_conf);
			}
			else if(action == "DEL")
			{
				link_elem.text(title);
				link_elem.attr('href', link.replace('del', 'add'));
				link_elem.attr('data-content', data.popover_content);
				link_elem.removeClass("btn-danger");
				link_elem.addClass("btn-success");
				$('.manage_catalog_book').popover(popover_book_index_conf);
			}
		});
	});
});

$(document).ready(function() {
	$('.shared_with').click(function(env){
		env.preventDefault();
		var link = $(this)
		email = $(this).parent().find('.shared_user_email').val();
		url = $(this).attr('href');
		$.get(url, {'email': email}, function(data) {
			console.log(data);
			html = '<tr><td>' + data[0] + '</td>' + '<td><a class="unshared_with btn btn-danger" href="' + data[1] + '">Unshare</a></td></tr>';
			console.log(link)
			link.parent().find('.table_shared').append(html)
		});
	});
});

$(document).ready(function() {
	$('.table_shared').on('click','tr a.unshared_with', function(env){
		env.preventDefault();
		var link = $(this);
		url = $(this).attr('href');
		$.get(url, function(data) {
			console.log(link);
			link.parent().parent().remove();
		});
		return false
	});
});

$(document).ready(function() {
	var $container = $('.thumbnails');

    $container.imagesLoaded( function(){
        $container.masonry({
            itemSelector : '.thumbnail',
            isAnimated: true,
            gutter: 5,
            columnWidth: 70
        });
    });
});

$('#show_category_tree').tree({
    data: category_data,
    autoEscape: false
});
		