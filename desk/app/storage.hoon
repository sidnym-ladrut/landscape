::  storage:
::
::  stores s3 keys for uploading and sharing images and objects
::
/-  *storage
/+  storage-json, default-agent, verb, dbug
~%  %s3-top  ..part  ~
|%
+$  card  card:agent:gall
+$  versioned-state
  $%  state-zero
      state-one
  ==
::
+$  state-zero  [%0 =credentials:zero:past =configuration:zero:past]
+$  state-one   [%1 =credentials =configuration]
--
::
=|  state-one
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
~%  %s3-agent-core  ..card  ~
|_  =bowl:gall
+*  this       .
    def        ~(. (default-agent this %|) bowl)
::
++  on-init
  ::  XX: deprecated; migration code
  ^-  (quip card _this)
  :_  this
  :~  :*  %pass
          /migrate
          %agent
          [our dap]:bowl
          %poke
          noun+!>(%migrate)
  ==  ==
++  on-save  !>(state)
++  on-load
  |=  =vase
  =/  old  !<(versioned-state vase)
  |^
  ?-  -.old
    %1  `this(state old)
    %0  `this(state (state-0-to-1 old))
  ==
  ++  state-0-to-1
    |=  zer=state-zero
    ^-  state-one
    :*  %1
        credentials.zer
        (configuration-0-to-1 configuration.zer)
    ==
  ++  configuration-0-to-1
    |=  conf=configuration:zero:past
    ^-  ^configuration
    :*  buckets.conf
        current-bucket.conf
        ''
    ==
  --
::
++  on-poke
  ~/  %s3-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ?>  (team:title our.bowl src.bowl)
  =^  cards  state
    ?+  mark  (on-poke:def mark vase)
        %storage-action
      (poke-action !<(action vase))
    ::
      ::  XX: deprecated; migration code
        %noun
      ?>  ?=(%migrate !<(%migrate vase))
      =/  bas  /(scot %p our.bowl)/s3-store/(scot %da now.bowl)
      :-  ~
      ?.  .^(? %gu bas)
        state
      =:
          credentials
        =/  ful  .^(update %gx (weld bas /credentials/noun))
        ?+  -.ful  (on-poke:def mark vase)
          %credentials  +.ful
        ==
      ::
          configuration
        =/  ful  .^(update %gx (weld bas /configuration/noun))
        ?+  -.ful  (on-poke:def mark vase)
          %configuration  +.ful
        ==  ==
      state
    ==
  [cards this]
  ::
  ++  poke-action
    |=  act=action
    ^-  (quip card _state)
    :-  [%give %fact [/all]~ %storage-update !>(act)]~
    ?-  -.act
        %set-endpoint
      state(endpoint.credentials endpoint.act)
    ::
        %set-access-key-id
      state(access-key-id.credentials access-key-id.act)
    ::
        %set-secret-access-key
      state(secret-access-key.credentials secret-access-key.act)
    ::
        %set-region
      state(region.configuration region.act)
    ::
        %set-current-bucket
      %_  state
          current-bucket.configuration  bucket.act
          buckets.configuration  (~(put in buckets.configuration) bucket.act)
      ==
    ::
        %add-bucket
      state(buckets.configuration (~(put in buckets.configuration) bucket.act))
    ::
        %remove-bucket
      state(buckets.configuration (~(del in buckets.configuration) bucket.act))
    ==
  --
::
++  on-watch
  ~/  %s3-watch
  |=  =path
  ^-  (quip card _this)
  |^
  ?>  (team:title our.bowl src.bowl)
  =/  cards=(list card)
    ?+  path      (on-watch:def path)
        [%all ~]
      :~  (give %storage-update !>([%credentials credentials]))
          (give %storage-update !>([%configuration configuration]))
      ==
    ==
  [cards this]
  ::
  ++  give
    |=  =cage
    ^-  card
    [%give %fact ~ cage]
  --
::
++  on-leave  on-leave:def
++  on-peek
  ~/  %s3-peek
  |=  =path
  ^-  (unit (unit cage))
  ?.  (team:title our.bowl src.bowl)  ~
  ?+    path  [~ ~]
      [%x %credentials ~]
    [~ ~ %storage-update !>(`update`[%credentials credentials])]
  ::
      [%x %configuration ~]
    [~ ~ %storage-update !>(`update`[%configuration configuration])]
  ==
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
