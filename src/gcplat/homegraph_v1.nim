
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: HomeGraph
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## 
## 
## https://developers.google.com/actions/smarthome/create-app#request-sync
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "homegraph"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_HomegraphDevicesQuery_588710 = ref object of OpenApiRestCall_588441
proc url_HomegraphDevicesQuery_588712(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_HomegraphDevicesQuery_588711(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the device states for the devices in QueryRequest.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("quotaUser")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "quotaUser", valid_588826
  var valid_588840 = query.getOrDefault("alt")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = newJString("json"))
  if valid_588840 != nil:
    section.add "alt", valid_588840
  var valid_588841 = query.getOrDefault("oauth_token")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "oauth_token", valid_588841
  var valid_588842 = query.getOrDefault("callback")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "callback", valid_588842
  var valid_588843 = query.getOrDefault("access_token")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "access_token", valid_588843
  var valid_588844 = query.getOrDefault("uploadType")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "uploadType", valid_588844
  var valid_588845 = query.getOrDefault("key")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "key", valid_588845
  var valid_588846 = query.getOrDefault("$.xgafv")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = newJString("1"))
  if valid_588846 != nil:
    section.add "$.xgafv", valid_588846
  var valid_588847 = query.getOrDefault("prettyPrint")
  valid_588847 = validateParameter(valid_588847, JBool, required = false,
                                 default = newJBool(true))
  if valid_588847 != nil:
    section.add "prettyPrint", valid_588847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_588871: Call_HomegraphDevicesQuery_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the device states for the devices in QueryRequest.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
  ## 
  let valid = call_588871.validator(path, query, header, formData, body)
  let scheme = call_588871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588871.url(scheme.get, call_588871.host, call_588871.base,
                         call_588871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588871, url, valid)

proc call*(call_588942: Call_HomegraphDevicesQuery_588710;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## homegraphDevicesQuery
  ## Gets the device states for the devices in QueryRequest.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588943 = newJObject()
  var body_588945 = newJObject()
  add(query_588943, "upload_protocol", newJString(uploadProtocol))
  add(query_588943, "fields", newJString(fields))
  add(query_588943, "quotaUser", newJString(quotaUser))
  add(query_588943, "alt", newJString(alt))
  add(query_588943, "oauth_token", newJString(oauthToken))
  add(query_588943, "callback", newJString(callback))
  add(query_588943, "access_token", newJString(accessToken))
  add(query_588943, "uploadType", newJString(uploadType))
  add(query_588943, "key", newJString(key))
  add(query_588943, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588945 = body
  add(query_588943, "prettyPrint", newJBool(prettyPrint))
  result = call_588942.call(nil, query_588943, nil, nil, body_588945)

var homegraphDevicesQuery* = Call_HomegraphDevicesQuery_588710(
    name: "homegraphDevicesQuery", meth: HttpMethod.HttpPost,
    host: "homegraph.googleapis.com", route: "/v1/devices:query",
    validator: validate_HomegraphDevicesQuery_588711, base: "/",
    url: url_HomegraphDevicesQuery_588712, schemes: {Scheme.Https})
type
  Call_HomegraphDevicesReportStateAndNotification_588984 = ref object of OpenApiRestCall_588441
proc url_HomegraphDevicesReportStateAndNotification_588986(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_HomegraphDevicesReportStateAndNotification_588985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reports device state and optionally sends device notifications. Called by
  ## an agent when the device state of a third-party changes or the agent wants
  ## to send a notification about the device. See
  ## [Implement Report State](/actions/smarthome/report-state) for more
  ## information.
  ## This method updates a predefined set of states for a device, which all
  ## devices have according to their prescribed traits (for example, a light
  ## will have the [OnOff](/actions/smarthome/traits/onoff) trait that reports
  ## the state `on` as a boolean value).
  ## A new state may not be created and an INVALID_ARGUMENT code will be thrown
  ## if so. It also optionally takes in a list of Notifications that may be
  ## created, which are associated to this state change.
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`.
  ## The agent is identified by the JWT signed by the partner's service account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588987 = query.getOrDefault("upload_protocol")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "upload_protocol", valid_588987
  var valid_588988 = query.getOrDefault("fields")
  valid_588988 = validateParameter(valid_588988, JString, required = false,
                                 default = nil)
  if valid_588988 != nil:
    section.add "fields", valid_588988
  var valid_588989 = query.getOrDefault("quotaUser")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "quotaUser", valid_588989
  var valid_588990 = query.getOrDefault("alt")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = newJString("json"))
  if valid_588990 != nil:
    section.add "alt", valid_588990
  var valid_588991 = query.getOrDefault("oauth_token")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = nil)
  if valid_588991 != nil:
    section.add "oauth_token", valid_588991
  var valid_588992 = query.getOrDefault("callback")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = nil)
  if valid_588992 != nil:
    section.add "callback", valid_588992
  var valid_588993 = query.getOrDefault("access_token")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "access_token", valid_588993
  var valid_588994 = query.getOrDefault("uploadType")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "uploadType", valid_588994
  var valid_588995 = query.getOrDefault("key")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "key", valid_588995
  var valid_588996 = query.getOrDefault("$.xgafv")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = newJString("1"))
  if valid_588996 != nil:
    section.add "$.xgafv", valid_588996
  var valid_588997 = query.getOrDefault("prettyPrint")
  valid_588997 = validateParameter(valid_588997, JBool, required = false,
                                 default = newJBool(true))
  if valid_588997 != nil:
    section.add "prettyPrint", valid_588997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_588999: Call_HomegraphDevicesReportStateAndNotification_588984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports device state and optionally sends device notifications. Called by
  ## an agent when the device state of a third-party changes or the agent wants
  ## to send a notification about the device. See
  ## [Implement Report State](/actions/smarthome/report-state) for more
  ## information.
  ## This method updates a predefined set of states for a device, which all
  ## devices have according to their prescribed traits (for example, a light
  ## will have the [OnOff](/actions/smarthome/traits/onoff) trait that reports
  ## the state `on` as a boolean value).
  ## A new state may not be created and an INVALID_ARGUMENT code will be thrown
  ## if so. It also optionally takes in a list of Notifications that may be
  ## created, which are associated to this state change.
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`.
  ## The agent is identified by the JWT signed by the partner's service account.
  ## 
  let valid = call_588999.validator(path, query, header, formData, body)
  let scheme = call_588999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588999.url(scheme.get, call_588999.host, call_588999.base,
                         call_588999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588999, url, valid)

proc call*(call_589000: Call_HomegraphDevicesReportStateAndNotification_588984;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## homegraphDevicesReportStateAndNotification
  ## Reports device state and optionally sends device notifications. Called by
  ## an agent when the device state of a third-party changes or the agent wants
  ## to send a notification about the device. See
  ## [Implement Report State](/actions/smarthome/report-state) for more
  ## information.
  ## This method updates a predefined set of states for a device, which all
  ## devices have according to their prescribed traits (for example, a light
  ## will have the [OnOff](/actions/smarthome/traits/onoff) trait that reports
  ## the state `on` as a boolean value).
  ## A new state may not be created and an INVALID_ARGUMENT code will be thrown
  ## if so. It also optionally takes in a list of Notifications that may be
  ## created, which are associated to this state change.
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`.
  ## The agent is identified by the JWT signed by the partner's service account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589001 = newJObject()
  var body_589002 = newJObject()
  add(query_589001, "upload_protocol", newJString(uploadProtocol))
  add(query_589001, "fields", newJString(fields))
  add(query_589001, "quotaUser", newJString(quotaUser))
  add(query_589001, "alt", newJString(alt))
  add(query_589001, "oauth_token", newJString(oauthToken))
  add(query_589001, "callback", newJString(callback))
  add(query_589001, "access_token", newJString(accessToken))
  add(query_589001, "uploadType", newJString(uploadType))
  add(query_589001, "key", newJString(key))
  add(query_589001, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589002 = body
  add(query_589001, "prettyPrint", newJBool(prettyPrint))
  result = call_589000.call(nil, query_589001, nil, nil, body_589002)

var homegraphDevicesReportStateAndNotification* = Call_HomegraphDevicesReportStateAndNotification_588984(
    name: "homegraphDevicesReportStateAndNotification", meth: HttpMethod.HttpPost,
    host: "homegraph.googleapis.com",
    route: "/v1/devices:reportStateAndNotification",
    validator: validate_HomegraphDevicesReportStateAndNotification_588985,
    base: "/", url: url_HomegraphDevicesReportStateAndNotification_588986,
    schemes: {Scheme.Https})
type
  Call_HomegraphDevicesRequestSync_589003 = ref object of OpenApiRestCall_588441
proc url_HomegraphDevicesRequestSync_589005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_HomegraphDevicesRequestSync_589004(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests a `SYNC` call from Google to a 3p partner's home control agent for
  ## a user.
  ## 
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`
  ## (see RequestSyncDevicesRequest) and forwarded back to the agent.
  ## The agent is identified by the API key or JWT signed by the partner's
  ## service account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589006 = query.getOrDefault("upload_protocol")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "upload_protocol", valid_589006
  var valid_589007 = query.getOrDefault("fields")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "fields", valid_589007
  var valid_589008 = query.getOrDefault("quotaUser")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "quotaUser", valid_589008
  var valid_589009 = query.getOrDefault("alt")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = newJString("json"))
  if valid_589009 != nil:
    section.add "alt", valid_589009
  var valid_589010 = query.getOrDefault("oauth_token")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "oauth_token", valid_589010
  var valid_589011 = query.getOrDefault("callback")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "callback", valid_589011
  var valid_589012 = query.getOrDefault("access_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "access_token", valid_589012
  var valid_589013 = query.getOrDefault("uploadType")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "uploadType", valid_589013
  var valid_589014 = query.getOrDefault("key")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "key", valid_589014
  var valid_589015 = query.getOrDefault("$.xgafv")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("1"))
  if valid_589015 != nil:
    section.add "$.xgafv", valid_589015
  var valid_589016 = query.getOrDefault("prettyPrint")
  valid_589016 = validateParameter(valid_589016, JBool, required = false,
                                 default = newJBool(true))
  if valid_589016 != nil:
    section.add "prettyPrint", valid_589016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589018: Call_HomegraphDevicesRequestSync_589003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests a `SYNC` call from Google to a 3p partner's home control agent for
  ## a user.
  ## 
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`
  ## (see RequestSyncDevicesRequest) and forwarded back to the agent.
  ## The agent is identified by the API key or JWT signed by the partner's
  ## service account.
  ## 
  let valid = call_589018.validator(path, query, header, formData, body)
  let scheme = call_589018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589018.url(scheme.get, call_589018.host, call_589018.base,
                         call_589018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589018, url, valid)

proc call*(call_589019: Call_HomegraphDevicesRequestSync_589003;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## homegraphDevicesRequestSync
  ## Requests a `SYNC` call from Google to a 3p partner's home control agent for
  ## a user.
  ## 
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`
  ## (see RequestSyncDevicesRequest) and forwarded back to the agent.
  ## The agent is identified by the API key or JWT signed by the partner's
  ## service account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589020 = newJObject()
  var body_589021 = newJObject()
  add(query_589020, "upload_protocol", newJString(uploadProtocol))
  add(query_589020, "fields", newJString(fields))
  add(query_589020, "quotaUser", newJString(quotaUser))
  add(query_589020, "alt", newJString(alt))
  add(query_589020, "oauth_token", newJString(oauthToken))
  add(query_589020, "callback", newJString(callback))
  add(query_589020, "access_token", newJString(accessToken))
  add(query_589020, "uploadType", newJString(uploadType))
  add(query_589020, "key", newJString(key))
  add(query_589020, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589021 = body
  add(query_589020, "prettyPrint", newJBool(prettyPrint))
  result = call_589019.call(nil, query_589020, nil, nil, body_589021)

var homegraphDevicesRequestSync* = Call_HomegraphDevicesRequestSync_589003(
    name: "homegraphDevicesRequestSync", meth: HttpMethod.HttpPost,
    host: "homegraph.googleapis.com", route: "/v1/devices:requestSync",
    validator: validate_HomegraphDevicesRequestSync_589004, base: "/",
    url: url_HomegraphDevicesRequestSync_589005, schemes: {Scheme.Https})
type
  Call_HomegraphDevicesSync_589022 = ref object of OpenApiRestCall_588441
proc url_HomegraphDevicesSync_589024(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_HomegraphDevicesSync_589023(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the devices associated with the given third-party user.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589025 = query.getOrDefault("upload_protocol")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "upload_protocol", valid_589025
  var valid_589026 = query.getOrDefault("fields")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "fields", valid_589026
  var valid_589027 = query.getOrDefault("quotaUser")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "quotaUser", valid_589027
  var valid_589028 = query.getOrDefault("alt")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = newJString("json"))
  if valid_589028 != nil:
    section.add "alt", valid_589028
  var valid_589029 = query.getOrDefault("oauth_token")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "oauth_token", valid_589029
  var valid_589030 = query.getOrDefault("callback")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "callback", valid_589030
  var valid_589031 = query.getOrDefault("access_token")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "access_token", valid_589031
  var valid_589032 = query.getOrDefault("uploadType")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "uploadType", valid_589032
  var valid_589033 = query.getOrDefault("key")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "key", valid_589033
  var valid_589034 = query.getOrDefault("$.xgafv")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("1"))
  if valid_589034 != nil:
    section.add "$.xgafv", valid_589034
  var valid_589035 = query.getOrDefault("prettyPrint")
  valid_589035 = validateParameter(valid_589035, JBool, required = false,
                                 default = newJBool(true))
  if valid_589035 != nil:
    section.add "prettyPrint", valid_589035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589037: Call_HomegraphDevicesSync_589022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the devices associated with the given third-party user.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
  ## 
  let valid = call_589037.validator(path, query, header, formData, body)
  let scheme = call_589037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589037.url(scheme.get, call_589037.host, call_589037.base,
                         call_589037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589037, url, valid)

proc call*(call_589038: Call_HomegraphDevicesSync_589022;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## homegraphDevicesSync
  ## Gets all the devices associated with the given third-party user.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589039 = newJObject()
  var body_589040 = newJObject()
  add(query_589039, "upload_protocol", newJString(uploadProtocol))
  add(query_589039, "fields", newJString(fields))
  add(query_589039, "quotaUser", newJString(quotaUser))
  add(query_589039, "alt", newJString(alt))
  add(query_589039, "oauth_token", newJString(oauthToken))
  add(query_589039, "callback", newJString(callback))
  add(query_589039, "access_token", newJString(accessToken))
  add(query_589039, "uploadType", newJString(uploadType))
  add(query_589039, "key", newJString(key))
  add(query_589039, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589040 = body
  add(query_589039, "prettyPrint", newJBool(prettyPrint))
  result = call_589038.call(nil, query_589039, nil, nil, body_589040)

var homegraphDevicesSync* = Call_HomegraphDevicesSync_589022(
    name: "homegraphDevicesSync", meth: HttpMethod.HttpPost,
    host: "homegraph.googleapis.com", route: "/v1/devices:sync",
    validator: validate_HomegraphDevicesSync_589023, base: "/",
    url: url_HomegraphDevicesSync_589024, schemes: {Scheme.Https})
type
  Call_HomegraphAgentUsersDelete_589041 = ref object of OpenApiRestCall_588441
proc url_HomegraphAgentUsersDelete_589043(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "agentUserId" in path, "`agentUserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "agentUserId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_HomegraphAgentUsersDelete_589042(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unlinks an agent user from Google. As a result, all data related to this
  ## user will be deleted.
  ## 
  ## Here is how the agent user is created in Google:
  ## 
  ## 1.  When a user opens their Google Home App, they can begin linking a 3p
  ##     partner.
  ## 2.  User is guided through the OAuth process.
  ## 3.  After entering the 3p credentials, Google gets the 3p OAuth token and
  ##     uses it to make a Sync call to the 3p partner and gets back all of the
  ##     user's data, including `agent_user_id` and devices.
  ## 4.  Google creates the agent user and stores a mapping from the
  ##     `agent_user_id` -> Google ID mapping. Google also
  ##     stores all of the user's devices under that Google ID.
  ## 
  ## The mapping from `agent_user_id` to Google ID is many to many, since one
  ## Google user can have multiple 3p accounts, and multiple Google users can
  ## map to one `agent_user_id` (e.g., a husband and wife share one Nest account
  ## username/password).
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`.
  ## The agent is identified by the JWT signed by the partner's service account.
  ## 
  ## Note: Special characters (except "/") in `agent_user_id` must be
  ## URL-encoded.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   agentUserId: JString (required)
  ##              : Required. Third-party user ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `agentUserId` field"
  var valid_589058 = path.getOrDefault("agentUserId")
  valid_589058 = validateParameter(valid_589058, JString, required = true,
                                 default = nil)
  if valid_589058 != nil:
    section.add "agentUserId", valid_589058
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : Request ID used for debugging.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589059 = query.getOrDefault("upload_protocol")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "upload_protocol", valid_589059
  var valid_589060 = query.getOrDefault("fields")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "fields", valid_589060
  var valid_589061 = query.getOrDefault("requestId")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "requestId", valid_589061
  var valid_589062 = query.getOrDefault("quotaUser")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "quotaUser", valid_589062
  var valid_589063 = query.getOrDefault("alt")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("json"))
  if valid_589063 != nil:
    section.add "alt", valid_589063
  var valid_589064 = query.getOrDefault("oauth_token")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "oauth_token", valid_589064
  var valid_589065 = query.getOrDefault("callback")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "callback", valid_589065
  var valid_589066 = query.getOrDefault("access_token")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "access_token", valid_589066
  var valid_589067 = query.getOrDefault("uploadType")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "uploadType", valid_589067
  var valid_589068 = query.getOrDefault("key")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "key", valid_589068
  var valid_589069 = query.getOrDefault("$.xgafv")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = newJString("1"))
  if valid_589069 != nil:
    section.add "$.xgafv", valid_589069
  var valid_589070 = query.getOrDefault("prettyPrint")
  valid_589070 = validateParameter(valid_589070, JBool, required = false,
                                 default = newJBool(true))
  if valid_589070 != nil:
    section.add "prettyPrint", valid_589070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589071: Call_HomegraphAgentUsersDelete_589041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unlinks an agent user from Google. As a result, all data related to this
  ## user will be deleted.
  ## 
  ## Here is how the agent user is created in Google:
  ## 
  ## 1.  When a user opens their Google Home App, they can begin linking a 3p
  ##     partner.
  ## 2.  User is guided through the OAuth process.
  ## 3.  After entering the 3p credentials, Google gets the 3p OAuth token and
  ##     uses it to make a Sync call to the 3p partner and gets back all of the
  ##     user's data, including `agent_user_id` and devices.
  ## 4.  Google creates the agent user and stores a mapping from the
  ##     `agent_user_id` -> Google ID mapping. Google also
  ##     stores all of the user's devices under that Google ID.
  ## 
  ## The mapping from `agent_user_id` to Google ID is many to many, since one
  ## Google user can have multiple 3p accounts, and multiple Google users can
  ## map to one `agent_user_id` (e.g., a husband and wife share one Nest account
  ## username/password).
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`.
  ## The agent is identified by the JWT signed by the partner's service account.
  ## 
  ## Note: Special characters (except "/") in `agent_user_id` must be
  ## URL-encoded.
  ## 
  let valid = call_589071.validator(path, query, header, formData, body)
  let scheme = call_589071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589071.url(scheme.get, call_589071.host, call_589071.base,
                         call_589071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589071, url, valid)

proc call*(call_589072: Call_HomegraphAgentUsersDelete_589041; agentUserId: string;
          uploadProtocol: string = ""; fields: string = ""; requestId: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## homegraphAgentUsersDelete
  ## Unlinks an agent user from Google. As a result, all data related to this
  ## user will be deleted.
  ## 
  ## Here is how the agent user is created in Google:
  ## 
  ## 1.  When a user opens their Google Home App, they can begin linking a 3p
  ##     partner.
  ## 2.  User is guided through the OAuth process.
  ## 3.  After entering the 3p credentials, Google gets the 3p OAuth token and
  ##     uses it to make a Sync call to the 3p partner and gets back all of the
  ##     user's data, including `agent_user_id` and devices.
  ## 4.  Google creates the agent user and stores a mapping from the
  ##     `agent_user_id` -> Google ID mapping. Google also
  ##     stores all of the user's devices under that Google ID.
  ## 
  ## The mapping from `agent_user_id` to Google ID is many to many, since one
  ## Google user can have multiple 3p accounts, and multiple Google users can
  ## map to one `agent_user_id` (e.g., a husband and wife share one Nest account
  ## username/password).
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`.
  ## The agent is identified by the JWT signed by the partner's service account.
  ## 
  ## Note: Special characters (except "/") in `agent_user_id` must be
  ## URL-encoded.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : Request ID used for debugging.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   agentUserId: string (required)
  ##              : Required. Third-party user ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589073 = newJObject()
  var query_589074 = newJObject()
  add(query_589074, "upload_protocol", newJString(uploadProtocol))
  add(query_589074, "fields", newJString(fields))
  add(query_589074, "requestId", newJString(requestId))
  add(query_589074, "quotaUser", newJString(quotaUser))
  add(query_589074, "alt", newJString(alt))
  add(query_589074, "oauth_token", newJString(oauthToken))
  add(query_589074, "callback", newJString(callback))
  add(query_589074, "access_token", newJString(accessToken))
  add(query_589074, "uploadType", newJString(uploadType))
  add(query_589074, "key", newJString(key))
  add(query_589074, "$.xgafv", newJString(Xgafv))
  add(path_589073, "agentUserId", newJString(agentUserId))
  add(query_589074, "prettyPrint", newJBool(prettyPrint))
  result = call_589072.call(path_589073, query_589074, nil, nil, nil)

var homegraphAgentUsersDelete* = Call_HomegraphAgentUsersDelete_589041(
    name: "homegraphAgentUsersDelete", meth: HttpMethod.HttpDelete,
    host: "homegraph.googleapis.com", route: "/v1/{agentUserId}",
    validator: validate_HomegraphAgentUsersDelete_589042, base: "/",
    url: url_HomegraphAgentUsersDelete_589043, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
