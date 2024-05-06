  let draggedItem = null;
  let parentItem = null;
  let inputItem = null;

  function clearInputValues(inputItem) {
      if (inputItem !== null) {
        inputItem.setAttribute("id-row", "");
        inputItem.setAttribute("value", "");
        inputItem = null;
      };

  };

  function dragNdrop() {
    const listItems = document.querySelectorAll(".rqti-list");
    const dropZones = document.querySelectorAll(".rqti-dropzone");
    const leftBox = document.querySelector("#rqti-left");

    for (let i = 0; 1 < listItems.length; i++) {
      const item = listItems[i];

      item.addEventListener('dragstart', () => {
        draggedItem = item;
        parentItem = draggedItem.parentElement;
        if (parentItem.className.includes("rqti-dropzone")) {
            inputItem = parentItem.parentElement.querySelector(".rqti-hidden");
        };
        setTimeout(() => {
          item.style.display = 'none';
        }, 0);
      });

      item.addEventListener("dragend", () => {
        if (parentItem.className.includes("rqti-dropzone") && parentItem.children.length == 0) {
          parentItem.textContent += "drop here";
        };
        setTimeout(() => {
          item.style.display = "block";
          draggedItem = null;
        });
      });

      for (let j  = 0; j < dropZones.length; j++) {
        const dropZone = dropZones[j];

        dropZone.addEventListener("dragover", e => e.preventDefault());

        dropZone.addEventListener("dragenter", function (e) {
          e.preventDefault();
          this.style.backgroundColor = 'rgba(0,0,0,.3)';
        });

        dropZone.addEventListener("dragleave", function(e) {
          this.style.backgroundColor = 'rgba(255,255,255,0)';
        });

        dropZone.addEventListener("drop", function(e) {
          let chld = e.target.children;
          let cls = e.target.className;

          if (chld.length > 1) {
            chld[0].style.margin = "6px";
            leftBox.append(chld[0]);
            //clearInputValues(inputItem);
          }

          if (cls.includes("rqti-list")) {
            e.target.style.margin = "6px";
            leftBox.append(e.target);
            clearInputValues(inputItem);
          }
          draggedItem.style.margin = "0px";

          let childs = this.childNodes;
          childs.forEach(c => {c.nodeType === Node.TEXT_NODE && c.remove()});

          this.appendChild(draggedItem);
          this.style.backgroundColor = 'rgba(255,255,255,0)';
          let id_row = draggedItem.getAttribute("id-row");
          inpt = this.parentElement.querySelector(".rqti-hidden");
          inpt.setAttribute("id-row", id_row);
          inpt.setAttribute("value", id_row + " " + inpt.getAttribute("id-col"));
        });

        leftBox.addEventListener("dragover", function(e) {
            e.preventDefault();
          });

        leftBox.addEventListener("drop", function(e) {
           if (draggedItem !== null){
            draggedItem.style.margin = "6px";
            this.append(draggedItem);
            clearInputValues(inputItem);
           };
           draggedItem = null;
        });

      };
    };

  };

  dragNdrop();
