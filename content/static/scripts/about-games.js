(function () {
  var lastTrigger = new WeakMap();
  var managedDialogs = new WeakSet();
  var lockedDialogCount = 0;
  var scrollState = null;

  function lockPageScroll() {
    if (lockedDialogCount > 0) {
      lockedDialogCount += 1;
      return;
    }

    var root = document.documentElement;
    var body = document.body;
    var scrollY = window.scrollY || root.scrollTop || 0;
    var scrollbarWidth = Math.max(0, window.innerWidth - root.clientWidth);

    scrollState = {
      scrollY: scrollY,
      rootOverflow: root.style.overflow,
      bodyLeft: body.style.left,
      bodyOverflow: body.style.overflow,
      bodyPaddingRight: body.style.paddingRight,
      bodyPosition: body.style.position,
      bodyRight: body.style.right,
      bodyTop: body.style.top,
      bodyWidth: body.style.width,
    };

    root.style.overflow = "hidden";
    body.style.overflow = "hidden";
    body.style.position = "fixed";
    body.style.top = "-" + scrollY + "px";
    body.style.left = "0";
    body.style.right = "0";
    body.style.width = "100%";

    if (scrollbarWidth > 0) {
      body.style.paddingRight = scrollbarWidth + "px";
    }

    lockedDialogCount = 1;
  }

  function unlockPageScroll() {
    if (lockedDialogCount === 0) {
      return;
    }

    lockedDialogCount -= 1;

    if (lockedDialogCount > 0 || !scrollState) {
      return;
    }

    var root = document.documentElement;
    var body = document.body;
    var scrollY = scrollState.scrollY;

    root.style.overflow = scrollState.rootOverflow;
    body.style.left = scrollState.bodyLeft;
    body.style.overflow = scrollState.bodyOverflow;
    body.style.paddingRight = scrollState.bodyPaddingRight;
    body.style.position = scrollState.bodyPosition;
    body.style.right = scrollState.bodyRight;
    body.style.top = scrollState.bodyTop;
    body.style.width = scrollState.bodyWidth;

    scrollState = null;
    window.scrollTo(0, scrollY);
  }

  function finishDialogClose(dialog) {
    if (!managedDialogs.has(dialog)) {
      return;
    }

    managedDialogs.delete(dialog);
    unlockPageScroll();

    var trigger = lastTrigger.get(dialog);
    if (trigger) {
      trigger.focus();
    }
  }

  function closeDialog(dialog) {
    if (!dialog || !dialog.open) {
      return;
    }

    if (typeof dialog.close === "function") {
      dialog.close();
      window.setTimeout(function () {
        finishDialogClose(dialog);
      }, 0);
      return;
    }

    dialog.removeAttribute("open");
    finishDialogClose(dialog);
  }

  function openDialog(dialog, trigger) {
    if (!dialog || dialog.open) {
      return;
    }

    lastTrigger.set(dialog, trigger);
    lockPageScroll();

    try {
      if (typeof dialog.showModal === "function") {
        dialog.showModal();
      } else {
        dialog.setAttribute("open", "");
      }

      managedDialogs.add(dialog);
    } catch (error) {
      unlockPageScroll();
      throw error;
    }
  }

  function setGalleryIndex(gallery, nextIndex) {
    var image = gallery.querySelector("[data-game-gallery-image]");
    var counter = gallery.querySelector("[data-game-gallery-counter]");
    var thumbs = Array.prototype.slice.call(gallery.querySelectorAll("[data-game-gallery-thumb]"));

    if (!image || thumbs.length === 0) {
      return;
    }

    var count = thumbs.length;
    var activeIndex = ((nextIndex % count) + count) % count;
    var activeThumb = thumbs[activeIndex];
    var activeSrc = activeThumb.getAttribute("data-game-gallery-src");

    if (activeSrc) {
      image.src = activeSrc;
    }

    if (counter) {
      counter.textContent = activeIndex + 1 + " / " + count;
    }

    thumbs.forEach(function (thumb, index) {
      if (index === activeIndex) {
        thumb.setAttribute("aria-current", "true");
        thumb.setAttribute("data-active", "true");
      } else {
        thumb.removeAttribute("aria-current");
        thumb.removeAttribute("data-active");
      }
    });

    gallery.setAttribute("data-game-gallery-index", String(activeIndex));
  }

  function currentGalleryIndex(gallery) {
    var index = Number(gallery.getAttribute("data-game-gallery-index"));
    return Number.isFinite(index) ? index : 0;
  }

  function setupGallery(gallery) {
    var thumbs = Array.prototype.slice.call(gallery.querySelectorAll("[data-game-gallery-thumb]"));
    var previousButton = gallery.querySelector("[data-game-gallery-prev]");
    var nextButton = gallery.querySelector("[data-game-gallery-next]");

    if (thumbs.length === 0) {
      return;
    }

    thumbs.forEach(function (thumb, index) {
      thumb.addEventListener("click", function () {
        setGalleryIndex(gallery, index);
      });
    });

    if (previousButton) {
      previousButton.addEventListener("click", function () {
        setGalleryIndex(gallery, currentGalleryIndex(gallery) - 1);
      });
    }

    if (nextButton) {
      nextButton.addEventListener("click", function () {
        setGalleryIndex(gallery, currentGalleryIndex(gallery) + 1);
      });
    }

    setGalleryIndex(gallery, currentGalleryIndex(gallery));
  }

  document.querySelectorAll("[data-game-modal]").forEach(function (button) {
    button.addEventListener("click", function () {
      var id = button.getAttribute("data-game-modal");
      var dialog = id ? document.getElementById(id) : null;
      openDialog(dialog, button);
    });
  });

  document.querySelectorAll("[data-game-dialog]").forEach(function (dialog) {
    dialog.querySelectorAll("[data-game-close]").forEach(function (button) {
      button.addEventListener("click", function () {
        closeDialog(dialog);
      });
    });

    dialog.addEventListener("click", function (event) {
      if (event.target === dialog) {
        closeDialog(dialog);
      }
    });

    dialog.addEventListener("cancel", function () {
      window.setTimeout(function () {
        if (!dialog.open) {
          finishDialogClose(dialog);
        }
      }, 0);
    });

    dialog.addEventListener("close", function () {
      finishDialogClose(dialog);
    });
  });

  document.querySelectorAll("[data-game-gallery]").forEach(setupGallery);
})();
