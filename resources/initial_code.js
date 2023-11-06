import jspdf from "https://cdn.skypack.dev/jspdf";

kit.text(`# PDF generator`);

const name = kit.input("Your Name");

if (kit.button("Generate")) {
  const doc = new jspdf();
  const image = new Image();
  image.src = "/images/harvard_diploma.png";
  await doc.addImage(image, "png", 0, 0, 200, 150);

  doc.text(name, 85, 80);
  doc.save("diploma.pdf");
}
