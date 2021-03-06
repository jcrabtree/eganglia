%%%-------------------------------------------------------------------
%%% @author Fernando Benavides <fernando.benavides@inakanetworks.com>
%%% @copyright (C) 2011 Inaka Labs SRL
%%% @doc erlang:memory/1 metrics
%%% @end
%%%-------------------------------------------------------------------

%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
-module(memory_metric).
-author('Fernando Benavides <fernando.benavides@inakanetworks.com>').

-behavior(gen_metric).

-record(state, {info :: term()}).
-opaque state() :: #state{}.

-export([add/2, delete/2]).
-export([init/1, handle_metric/1, handle_call/2, handle_cast/2, terminate/2]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% API FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% @doc Adds the metric to the group. The value will come from erlang:memory(Info)
-spec add(metric_group:group(), term()) -> ok | {error, already_present | term()}.
add(Group, Info) ->
  metric_group:add_metric(Group, {?MODULE, Info}, ?MODULE, Info).

%% @doc Removes the metric from the group
-spec delete(metric_group:group(), term()) -> ok | {error, not_found}.
delete(Group, Info) ->
  metric_group:delete_metric(Group, {?MODULE, Info}, normal).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% API FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% @private
-spec init(term()) -> {ok, binary(), state()}.
init(Info) ->
  {ok, erlang:iolist_to_binary(io_lib:format("~p memory", [Info])), #state{info = Info}}.

%% @private
-spec handle_metric(state()) -> {ok, pos_integer(), state()}.
handle_metric(State = #state{info = Info}) -> {ok, erlang:memory(Info), State}.

%% @private
-spec handle_call(Any, state()) -> {stop, {unexpected_call, Any}, {unexpected_call, Any}, state()}.
handle_call(Any, State) -> {stop, {unexpected_call, Any}, {unexpected_call, Any}, State}.

%% @private
-spec handle_cast(Any, state()) -> {stop, {unexpected_cast, Any}, state()}.
handle_cast(Any, State) -> {stop, {unexpected_cast, Any}, State}.

%% @private
-spec terminate(term(), state()) -> ok.
terminate(_Reason, _State) -> ok.