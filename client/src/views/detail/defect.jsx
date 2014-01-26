/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		ReactView = require('views/base/react_view'),
      DetailMixin = require('views/detail/detail_mixin'),
  		Defects = require('views/field/defects'),
  		Description = require('views/field/description'),
  		Discussion = require('views/field/discussion'),
  		Name = require('views/field/name'),
      Owner = require('views/field/owner'),
  		Tasks = require('views/field/tasks'),
      WorkProduct = require('views/field/work_product'),
  		TitledWell = require('views/field/titled_well'),
  		Toggle = require('views/field/toggle'),
  		StringWithArrows = require('views/field/string_with_arrows');

  return ReactView.createChaplinClass({
    mixins: [DetailMixin],
  	render: function() {
      var model = this.props.model,
          newArtifact = this.props.newArtifact;
  		return (
  			<div className="detail-view">
  			  <div className="row">
  			    <div className="col-xs-12 NameView">
  			  		<Name item={ model } editMode={ newArtifact }/>
  			    </div>
  			  </div>
          <div className="row">
            <div className="col-xs-12 ellipsis RequirementView">
              <WorkProduct item={ model } editMode={ newArtifact } field="Requirement"/>
            </div>
          </div>
          <div className="row">
            <div className="col-xs-8">
              <div className="row">
                <div className="col-xs-12 ScheduleStateView">
                  <StringWithArrows item={ model } editMode={ newArtifact } field={ this.getBoardField() } label={ this.getScheduleStateLabel() }/>
                </div>
              </div>
              <div className="row">
                <div className="col-xs-12 StateView">
                  <StringWithArrows item={ model } editMode={ newArtifact } field="State" label="State"/>
                </div>
              </div>
            </div>
            <div className="col-xs-4 OwnerView">
              <Owner item={ model } editMode={ newArtifact }/>
            </div>
          </div>
          <div className="row">
            <div className="col-xs-4 PlanEstimateView">
              <TitledWell item={ model } editMode={ newArtifact } field='PlanEstimate' label='Plan Est' inputType='number'/>
            </div>
            <div className="col-xs-4 TasksView">
              <Tasks item={ model } editMode={ newArtifact }/>
            </div>
            <div className="col-xs-4 DiscussionView">
              <Discussion item={ model } editMode={ newArtifact }/>
            </div>
          </div>
          <div className="row">
            <div className="col-xs-6 SeverityView">
              <TitledWell item={ model } editMode={ newArtifact } field='Severity' label='Severity'/>
            </div>
            <div className="col-xs-6 PriorityView">
              <TitledWell item={ model } editMode={ newArtifact } field='Priority' label='Priority'/>
            </div>
          </div>
          <div className="row">
            <div className="col-xs-12 DescriptionView">
              <Description item={ model } editMode={ newArtifact }/>
            </div>
          </div>
          { newArtifact ? this.getButtonsMarkup() : this.getTogglesMarkup() }
  			</div>
  		);
  	}
  });
});