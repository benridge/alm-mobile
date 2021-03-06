/** @jsx React.DOM */
var React = require('react');
var moment = require('moment');
var app = require('application');
var ReactView = require('views/base/react_view');

module.exports = ReactView.createBackboneClass({
  render: function() {
    var iteration = this.props.iteration;
    var iterations = this.props.iterations;
    var currentIndex = iteration && iterations && iterations.indexOf(iteration);
    var iterationHeader;
    if (iteration && this.props.visible) {
      iterationHeader = (
        <div>
          <div className="iteration-header"
               role="heading"
                aria-label={
                  "Current iteration: " + iteration.get('Name') +
                  ". From " + moment(iteration.get('StartDate')).format('LL') + " to " + moment(iteration.get('EndDate')).format('LL')
                }>
            <span>Iteration:</span>
            { this._getShowLeftMarkup(currentIndex) }
            <div className="iteration-data"
                 tabIndex="0"
                 role="link"
                 aria-label="Click to view iteration details"
                 onClick={ this._onSelect }
                 onKeyDown={ this.handleEnterAsClick(this._onSelect) }>
              <div className="name">{iteration.get('Name')}</div>
              <div className="dates">{moment(iteration.get('StartDate')).format('L')} - {moment(iteration.get('EndDate')).format('L')}</div>
            </div>
            { this._getShowRightMarkup(currentIndex) }
          </div>
        </div>
      );
    } else {
      iterationHeader = <div/>;
    }
    return iterationHeader;
  },

  _getShowLeftMarkup: function(currentIndex) {
    if (this.props.iterations && currentIndex < this.props.iterations.length - 1) {
      return (
        <span className="iteration-arrow">
          <i className="go-left icon-chevron-left"
             onClick={this._onChangeFn(this.props.iterations.at(currentIndex + 1))}
             onKeyDown={this.handleEnterAsClick(this._onChangeFn(this.props.iterations.at(currentIndex + 1)))}
             role="link"
             aria-label="Go to previous iteration"
             tabIndex="0"/>
        </span>
      );
    }
    return <span style={{ display: 'none' }}/>;
  },

  _getShowRightMarkup: function(currentIndex) {
    if (this.props.iterations && currentIndex > 0) {
      return (
        <span className="iteration-arrow">
          <i className="go-right icon-chevron-right"
             onClick={this._onChangeFn(this.props.iterations.at(currentIndex - 1))}
             onKeyDown={this.handleEnterAsClick(this._onChangeFn(this.props.iterations.at(currentIndex - 1)))}
             role="link"
             aria-label="Go to next iteration"
             tabIndex="0"/>
        </span>
      );
    }
    return <span style={{ display: 'none' }}/>;
  },

  _onChangeFn: function(iteration) {
    return _.bind(function(e) {
      app.aggregator.recordAction({ component: this, description: "Clicked iteration arrow" });
      this.props.onChange(this, iteration);
      e.preventDefault();
    }, this);
  },

  _onSelect: function(e) {
      app.aggregator.recordAction({ component: this, description: "Clicked iteration" });
      this.props.onSelect(this, this.props.iteration);
      e.preventDefault();
  }
});
