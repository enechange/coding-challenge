/**
 * スムーズスクロール
 */
export default class Scroller {
  constructor(options) {
    this.options = options;
  }

  /**
   * 初期化
   */
  init() {
    this.$button = $('.js-Scroller');

    this.$button.on('click', e => {
      e.preventDefault();
      this.scroll($(e.currentTarget));
      return false;
    });
  }

  /**
   * スクロール処理
   * @param $el {Object} - クリックされた要素
   */
  scroll($el) {
    const href = $el.attr('href');
    const targetId = $(href === '#' || href === '' ? 'html' : href);
    $('body,html').animate(
      {
        scrollTop: targetId.offset().top,
      },
      300,
      'swing'
    );
  }
}
