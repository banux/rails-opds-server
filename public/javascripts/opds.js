$(function(){
    $(".selectable").selectable();

    $("#add_book").click(function(ev){
        var catalog_id = $('#catalog_id').val();
        var books = $('#not_added .ui-selected');
        for(i = 0; i < books.length; i++)
        {
            book = books[i]
            book_id_str = $(book).attr('id');
            book_id = book_id_str.slice(5);
            $.get('/catalogs/' + catalog_id + '/add_book', {
                "book_id":book_id
            })
            $('#added').append(books[i]);
        //books[i].removeClass("ui-selected");
        }
        ev.preventDefault();

    });

    $("#remove_book").click(function(ev){
        var catalog_id = $('#catalog_id').val();
        var books = $('#added .ui-selected');
        for(i = 0; i < books.length; i++)
        {
            book = books[i]
            book_id_str = $(book).attr('id');
            book_id = book_id_str.slice(5);
            $.get('/catalogs/' + catalog_id + '/del_book', {
                "book_id":book_id
            })
            $('#not_added').append(books[i]);
        //books[i].removeClass("ui-selected");
        }
        ev.preventDefault();

    });

});
