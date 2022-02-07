(function(){
    let links = Object.values(document.getElementsByTagName("table")[0].getElementsByTagName('a'));
    let data = "";
    links.forEach(link => {
        if (link.innerHTML.includes(" - ")) {
            data += link.href + "\n";
        }
    });
    // Export to file
    let anchor = document.createElement('a');
    anchor.href = 'data:text/plain;charset=utf-8,' + encodeURIComponent(data);
    anchor.download = 'survey.txt';
    anchor.click();
})();