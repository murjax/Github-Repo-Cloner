import clone_page_handler

def clone_all(username):
    has_next_page = True
    page = 1
    while has_next_page:
        has_next_page = clone_page_handler.clone(username, page)
        page += 1
