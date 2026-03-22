const statusEl = document.getElementById("status");
const counterEl = document.getElementById("counterText");
const incBtn = document.getElementById("incrementBtn");

statusEl.textContent = "Page loaded successfully.";

let count = 0;
incBtn.addEventListener("click", () => {
  count += 1;
  counterEl.textContent = String(count);
});
