// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import 'bootstrap';
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

const initIngredientAutocomplete = () => {
  document.querySelectorAll("[data-ingredient-autocomplete]").forEach((container) => {
    if (container.dataset.enhanced === "true") return;
    container.dataset.enhanced = "true";

    const input = container.querySelector("[data-ingredient-autocomplete-input]");
    const hiddenInput = container.querySelector("[data-ingredient-autocomplete-value]");
    const list = container.querySelector("[data-ingredient-autocomplete-list]");
    if (!input || !hiddenInput || !list) return;

    const options = Array.from(list.querySelectorAll(".ingredient-autocomplete-option"));
    const normalize = (value) => value.toLowerCase().trim();
    let highlightedIndex = -1;

    const visibleOptions = () => options.filter((option) => !option.hidden);

    const closeList = () => {
      list.classList.remove("is-open");
      input.setAttribute("aria-expanded", "false");
      highlightedIndex = -1;
      options.forEach((option) => option.classList.remove("is-highlighted"));
    };

    const openList = () => {
      list.classList.add("is-open");
      input.setAttribute("aria-expanded", "true");
    };

    const setHighlighted = (index) => {
      const currentVisible = visibleOptions();
      currentVisible.forEach((option) => option.classList.remove("is-highlighted"));
      if (index < 0 || index >= currentVisible.length) {
        highlightedIndex = -1;
        return;
      }
      highlightedIndex = index;
      currentVisible[index].classList.add("is-highlighted");
    };

    const selectOption = (option) => {
      input.value = option.textContent.trim();
      hiddenInput.value = option.dataset.ingredientId;
      input.setCustomValidity("");
      closeList();
    };

    const filterOptions = () => {
      const query = normalize(input.value);
      hiddenInput.value = "";

      options.forEach((option) => {
        const matches = normalize(option.dataset.ingredientName).includes(query);
        option.hidden = !matches;
      });

      const anyVisible = visibleOptions().length > 0;
      if (anyVisible) {
        openList();
        setHighlighted(0);
      } else {
        closeList();
      }
    };

    const selectExactMatchIfExists = () => {
      const query = normalize(input.value);
      if (!query) return;

      const exactMatch = options.find((option) => normalize(option.dataset.ingredientName) === query);
      if (exactMatch) {
        selectOption(exactMatch);
      }
    };

    options.forEach((option) => {
      option.addEventListener("mousedown", (event) => {
        event.preventDefault();
        selectOption(option);
      });
    });

    input.addEventListener("focus", () => {
      options.forEach((option) => (option.hidden = false));
      openList();
      setHighlighted(0);
    });

    input.addEventListener("input", filterOptions);

    input.addEventListener("keydown", (event) => {
      const currentVisible = visibleOptions();
      if (event.key === "ArrowDown") {
        event.preventDefault();
        if (!list.classList.contains("is-open")) openList();
        setHighlighted(Math.min(highlightedIndex + 1, currentVisible.length - 1));
      } else if (event.key === "ArrowUp") {
        event.preventDefault();
        setHighlighted(Math.max(highlightedIndex - 1, 0));
      } else if (event.key === "Enter" && list.classList.contains("is-open")) {
        event.preventDefault();
        const option = currentVisible[highlightedIndex] || currentVisible[0];
        if (option) selectOption(option);
      } else if (event.key === "Escape") {
        closeList();
      }
    });

    input.closest("form").addEventListener("submit", (event) => {
      selectExactMatchIfExists();
      if (!hiddenInput.value) {
        event.preventDefault();
        input.setCustomValidity("Please select an ingredient from the list.");
        input.reportValidity();
      }
    });

    input.addEventListener("blur", () => {
      setTimeout(closeList, 120);
    });
  });
};

const initFileDropzones = () => {
  document.querySelectorAll("[data-file-dropzone]").forEach((container) => {
    if (container.dataset.enhanced === "true") return;
    container.dataset.enhanced = "true";

    const zone = container.querySelector("[data-file-dropzone-zone]");
    const input = container.querySelector("[data-file-dropzone-input]");
    const nameLabel = container.querySelector("[data-file-dropzone-name]");
    if (!zone || !input || !nameLabel) return;

    const updateLabel = () => {
      const fileName = input.files && input.files[0] ? input.files[0].name : "No file selected";
      nameLabel.textContent = fileName;
    };

    const openPicker = () => input.click();

    zone.addEventListener("click", (event) => {
      if (event.target !== input) openPicker();
    });

    zone.addEventListener("keydown", (event) => {
      if (event.key === "Enter" || event.key === " ") {
        event.preventDefault();
        openPicker();
      }
    });

    zone.addEventListener("dragover", (event) => {
      event.preventDefault();
      zone.classList.add("is-dragover");
    });

    zone.addEventListener("dragleave", () => {
      zone.classList.remove("is-dragover");
    });

    zone.addEventListener("drop", (event) => {
      event.preventDefault();
      zone.classList.remove("is-dragover");
      const files = event.dataTransfer ? event.dataTransfer.files : null;
      if (!files || files.length === 0) return;
      input.files = files;
      input.dispatchEvent(new Event("change", { bubbles: true }));
    });

    input.addEventListener("change", updateLabel);
    updateLabel();
  });
};

const initModernFormUI = () => {
  initIngredientAutocomplete();
  initFileDropzones();
};

const initThemeToggle = () => {
  const body = document.body;
  const toggleButton = document.querySelector("[data-theme-toggle]");
  if (!body || !toggleButton) return;
  if (toggleButton.dataset.enhanced === "true") return;
  toggleButton.dataset.enhanced = "true";

  const storageKey = "mister-cocktail-theme";
  const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
  const storedTheme = localStorage.getItem(storageKey);

  const applyTheme = (theme) => {
    const isDark = theme === "dark";
    body.classList.toggle("dark-mode", isDark);
    toggleButton.setAttribute("aria-pressed", String(isDark));
    toggleButton.setAttribute("aria-label", isDark ? "Enable day mode" : "Enable night mode");
    toggleButton.innerHTML = `<span aria-hidden="true">${isDark ? "☀" : "☾"}</span>`;
  };

  const initialTheme = storedTheme || (mediaQuery.matches ? "dark" : "light");
  applyTheme(initialTheme);

  toggleButton.addEventListener("click", () => {
    const nextTheme = body.classList.contains("dark-mode") ? "light" : "dark";
    localStorage.setItem(storageKey, nextTheme);
    applyTheme(nextTheme);
  });
};

document.addEventListener("turbolinks:load", initModernFormUI);
document.addEventListener("turbolinks:load", initThemeToggle);
