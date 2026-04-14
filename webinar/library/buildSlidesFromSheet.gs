// Google Apps Script — сборка презентации из таблицы (вкладка slides)
// Запуск: Слайды → Собрать презентацию
//
// Зависимости:
//   PRESENTATION_ID — ID Google Презентации (шаблонный слайд = первый)
//   SHEET_NAME      — вкладка таблицы с данными
//   IMAGES_FOLDER_ID — ID папки Drive с картинками (png/jpg/gif)
//
// Колонки таблицы: num | element | title | body | notes | img_tag
//   body/notes — разделитель " · " заменяется на \n
//   img_tag    — имя файла (image62.png) или [текст ТЗ] для плейсхолдера

const PRESENTATION_ID = '1LgLQqRiMBvVpMPeFtRiyADSMWcwZmfx9pzdEz0kzP2Y';
const SHEET_NAME = 'slides';
const IMAGES_FOLDER_ID = '1UwlBZVTPJ46wXqhUrXnlvb4dTxfGyXnM';

function buildSlidesFromSheet() {
  const pres = SlidesApp.openById(PRESENTATION_ID);
  const templateSlide = pres.getSlides()[0];
  const sheet = SpreadsheetApp.getActive().getSheetByName(SHEET_NAME);
  const rows = sheet.getDataRange().getValues();
  const imageCache = buildImageCache();

  for (let i = 1; i < rows.length; i++) {
    const [num, element, title, body, notes, imgTag] = rows[i];
    if (!title && !body && !notes) continue;

    const slide = templateSlide.duplicate();
    slide.move(pres.getSlides().length);

    const bodyFormatted = body ? body.replace(/ · /g, '\n') : '';
    const notesFormatted = notes ? notes.replace(/ · /g, '\n') : '';

    slide.getPageElements().forEach(el => {
      if (el.getPageElementType() !== SlidesApp.PageElementType.SHAPE) return;
      const shape = el.asShape();
      const textRange = shape.getText();
      const text = textRange.asString();
      if (text.includes('{{TITLE}}')) textRange.setText(title || '');
      if (text.includes('{{BODY}}')) textRange.setText(bodyFormatted);
    });

    if (imgTag && imgTag.toString().trim()) {
      const tag = imgTag.toString().trim();

      if (tag.startsWith('[')) {
        insertPlaceholder(slide, tag);
      } else {
        insertImage(slide, tag, imageCache);
      }
    }

    const notesPage = slide.getNotesPage();
    const notesShape = notesPage.getSpeakerNotesShape();
    notesShape.getText().setText(notesFormatted);
  }

  Logger.log('Готово. Создано слайдов: ' + (pres.getSlides().length - 1));
}

function buildImageCache() {
  const folder = DriveApp.getFolderById(IMAGES_FOLDER_ID);
  const files = folder.getFiles();
  const cache = {};
  const validMimeTypes = ['image/png', 'image/jpeg', 'image/gif'];

  while (files.hasNext()) {
    const file = files.next();
    const mimeType = file.getMimeType();

    if (!validMimeTypes.includes(mimeType)) {
      Logger.log('Пропущен (не изображение): ' + file.getName() + ' [' + mimeType + ']');
      continue;
    }

    const name = file.getName();
    const baseName = name.replace(/\.(png|jpg|jpeg|gif)$/i, '').toLowerCase();
    cache[baseName] = file.getBlob();
  }

  Logger.log('Загружено файлов: ' + Object.keys(cache).length);
  return cache;
}

function insertImage(slide, imgTag, imageCache) {
  const key = imgTag.toLowerCase().trim().replace(/\.(png|jpg|jpeg|gif)$/i, '');
  const blob = imageCache[key];

  if (!blob) {
    Logger.log('Картинка не найдена: ' + imgTag);
    insertPlaceholder(slide, '[Картинка не найдена: ' + imgTag + ']');
    return;
  }

  try {
    slide.insertImage(blob, 705, 423, 407, 407);
  } catch (e) {
    Logger.log('Ошибка вставки "' + imgTag + '": ' + e.message);
  }
}

function insertPlaceholder(slide, tzText) {
  try {
    const shape = slide.insertShape(
      SlidesApp.ShapeType.RECTANGLE,
      705, 423, 407, 407
    );

    shape.getFill().setSolidFill('#E8E8E8');
    shape.getBorder().setWeight(1);
    shape.getBorder().getLineFill().setSolidFill('#CCCCCC');

    const textRange = shape.getText();
    const cleanText = tzText.replace(/^\[/, '').replace(/\]$/, '');
    textRange.setText(cleanText);

    const style = textRange.getTextStyle();
    style.setFontSize(16);
    style.setForegroundColor('#444444');
    style.setBold(true);
    style.setFontFamily('Arial');

    const paragraphStyle = textRange.getParagraphStyle();
    paragraphStyle.setParagraphAlignment(SlidesApp.ParagraphAlignment.CENTER);

    Logger.log('ТЗ-плейсхолдер: ' + cleanText.substring(0, 50));
  } catch (e) {
    Logger.log('Ошибка плейсхолдера: ' + e.message);
  }
}

function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu('Слайды')
    .addItem('Собрать презентацию', 'buildSlidesFromSheet')
    .addToUi();
}
