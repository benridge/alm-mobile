var $ = require('jquery');
var Messageable = require('lib/messageable');

beforeEach(function() {
    this.stubViewRender = function(Controller, config) {
        var View = function() {};
        _.extend(View.prototype, Messageable);
        _.extend(View.prototype, {
            setState: this.stub()
        });
        _.extend(View.prototype, config);
        var stub = this.stub(Controller.prototype, 'renderReactComponent', function() {
            d = $.Deferred();
            d.resolve(new View());
            return d.promise();
        });
        return stub;
    };
});