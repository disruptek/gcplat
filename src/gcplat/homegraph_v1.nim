
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "homegraph"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_HomegraphDevicesQuery_578610 = ref object of OpenApiRestCall_578339
proc url_HomegraphDevicesQuery_578612(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_HomegraphDevicesQuery_578611(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("$.xgafv")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = newJString("1"))
  if valid_578740 != nil:
    section.add "$.xgafv", valid_578740
  var valid_578741 = query.getOrDefault("alt")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = newJString("json"))
  if valid_578741 != nil:
    section.add "alt", valid_578741
  var valid_578742 = query.getOrDefault("uploadType")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "uploadType", valid_578742
  var valid_578743 = query.getOrDefault("quotaUser")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "quotaUser", valid_578743
  var valid_578744 = query.getOrDefault("callback")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "callback", valid_578744
  var valid_578745 = query.getOrDefault("fields")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "fields", valid_578745
  var valid_578746 = query.getOrDefault("access_token")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "access_token", valid_578746
  var valid_578747 = query.getOrDefault("upload_protocol")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "upload_protocol", valid_578747
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

proc call*(call_578771: Call_HomegraphDevicesQuery_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the device states for the devices in QueryRequest.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
  ## 
  let valid = call_578771.validator(path, query, header, formData, body)
  let scheme = call_578771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578771.url(scheme.get, call_578771.host, call_578771.base,
                         call_578771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578771, url, valid)

proc call*(call_578842: Call_HomegraphDevicesQuery_578610; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## homegraphDevicesQuery
  ## Gets the device states for the devices in QueryRequest.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578843 = newJObject()
  var body_578845 = newJObject()
  add(query_578843, "key", newJString(key))
  add(query_578843, "prettyPrint", newJBool(prettyPrint))
  add(query_578843, "oauth_token", newJString(oauthToken))
  add(query_578843, "$.xgafv", newJString(Xgafv))
  add(query_578843, "alt", newJString(alt))
  add(query_578843, "uploadType", newJString(uploadType))
  add(query_578843, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578845 = body
  add(query_578843, "callback", newJString(callback))
  add(query_578843, "fields", newJString(fields))
  add(query_578843, "access_token", newJString(accessToken))
  add(query_578843, "upload_protocol", newJString(uploadProtocol))
  result = call_578842.call(nil, query_578843, nil, nil, body_578845)

var homegraphDevicesQuery* = Call_HomegraphDevicesQuery_578610(
    name: "homegraphDevicesQuery", meth: HttpMethod.HttpPost,
    host: "homegraph.googleapis.com", route: "/v1/devices:query",
    validator: validate_HomegraphDevicesQuery_578611, base: "/",
    url: url_HomegraphDevicesQuery_578612, schemes: {Scheme.Https})
type
  Call_HomegraphDevicesReportStateAndNotification_578884 = ref object of OpenApiRestCall_578339
proc url_HomegraphDevicesReportStateAndNotification_578886(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_HomegraphDevicesReportStateAndNotification_578885(path: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578887 = query.getOrDefault("key")
  valid_578887 = validateParameter(valid_578887, JString, required = false,
                                 default = nil)
  if valid_578887 != nil:
    section.add "key", valid_578887
  var valid_578888 = query.getOrDefault("prettyPrint")
  valid_578888 = validateParameter(valid_578888, JBool, required = false,
                                 default = newJBool(true))
  if valid_578888 != nil:
    section.add "prettyPrint", valid_578888
  var valid_578889 = query.getOrDefault("oauth_token")
  valid_578889 = validateParameter(valid_578889, JString, required = false,
                                 default = nil)
  if valid_578889 != nil:
    section.add "oauth_token", valid_578889
  var valid_578890 = query.getOrDefault("$.xgafv")
  valid_578890 = validateParameter(valid_578890, JString, required = false,
                                 default = newJString("1"))
  if valid_578890 != nil:
    section.add "$.xgafv", valid_578890
  var valid_578891 = query.getOrDefault("alt")
  valid_578891 = validateParameter(valid_578891, JString, required = false,
                                 default = newJString("json"))
  if valid_578891 != nil:
    section.add "alt", valid_578891
  var valid_578892 = query.getOrDefault("uploadType")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = nil)
  if valid_578892 != nil:
    section.add "uploadType", valid_578892
  var valid_578893 = query.getOrDefault("quotaUser")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = nil)
  if valid_578893 != nil:
    section.add "quotaUser", valid_578893
  var valid_578894 = query.getOrDefault("callback")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "callback", valid_578894
  var valid_578895 = query.getOrDefault("fields")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "fields", valid_578895
  var valid_578896 = query.getOrDefault("access_token")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "access_token", valid_578896
  var valid_578897 = query.getOrDefault("upload_protocol")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "upload_protocol", valid_578897
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

proc call*(call_578899: Call_HomegraphDevicesReportStateAndNotification_578884;
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
  let valid = call_578899.validator(path, query, header, formData, body)
  let scheme = call_578899.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578899.url(scheme.get, call_578899.host, call_578899.base,
                         call_578899.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578899, url, valid)

proc call*(call_578900: Call_HomegraphDevicesReportStateAndNotification_578884;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578901 = newJObject()
  var body_578902 = newJObject()
  add(query_578901, "key", newJString(key))
  add(query_578901, "prettyPrint", newJBool(prettyPrint))
  add(query_578901, "oauth_token", newJString(oauthToken))
  add(query_578901, "$.xgafv", newJString(Xgafv))
  add(query_578901, "alt", newJString(alt))
  add(query_578901, "uploadType", newJString(uploadType))
  add(query_578901, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578902 = body
  add(query_578901, "callback", newJString(callback))
  add(query_578901, "fields", newJString(fields))
  add(query_578901, "access_token", newJString(accessToken))
  add(query_578901, "upload_protocol", newJString(uploadProtocol))
  result = call_578900.call(nil, query_578901, nil, nil, body_578902)

var homegraphDevicesReportStateAndNotification* = Call_HomegraphDevicesReportStateAndNotification_578884(
    name: "homegraphDevicesReportStateAndNotification", meth: HttpMethod.HttpPost,
    host: "homegraph.googleapis.com",
    route: "/v1/devices:reportStateAndNotification",
    validator: validate_HomegraphDevicesReportStateAndNotification_578885,
    base: "/", url: url_HomegraphDevicesReportStateAndNotification_578886,
    schemes: {Scheme.Https})
type
  Call_HomegraphDevicesRequestSync_578903 = ref object of OpenApiRestCall_578339
proc url_HomegraphDevicesRequestSync_578905(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_HomegraphDevicesRequestSync_578904(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578906 = query.getOrDefault("key")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "key", valid_578906
  var valid_578907 = query.getOrDefault("prettyPrint")
  valid_578907 = validateParameter(valid_578907, JBool, required = false,
                                 default = newJBool(true))
  if valid_578907 != nil:
    section.add "prettyPrint", valid_578907
  var valid_578908 = query.getOrDefault("oauth_token")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "oauth_token", valid_578908
  var valid_578909 = query.getOrDefault("$.xgafv")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("1"))
  if valid_578909 != nil:
    section.add "$.xgafv", valid_578909
  var valid_578910 = query.getOrDefault("alt")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = newJString("json"))
  if valid_578910 != nil:
    section.add "alt", valid_578910
  var valid_578911 = query.getOrDefault("uploadType")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "uploadType", valid_578911
  var valid_578912 = query.getOrDefault("quotaUser")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "quotaUser", valid_578912
  var valid_578913 = query.getOrDefault("callback")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "callback", valid_578913
  var valid_578914 = query.getOrDefault("fields")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "fields", valid_578914
  var valid_578915 = query.getOrDefault("access_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "access_token", valid_578915
  var valid_578916 = query.getOrDefault("upload_protocol")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "upload_protocol", valid_578916
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

proc call*(call_578918: Call_HomegraphDevicesRequestSync_578903; path: JsonNode;
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
  let valid = call_578918.validator(path, query, header, formData, body)
  let scheme = call_578918.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578918.url(scheme.get, call_578918.host, call_578918.base,
                         call_578918.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578918, url, valid)

proc call*(call_578919: Call_HomegraphDevicesRequestSync_578903; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## homegraphDevicesRequestSync
  ## Requests a `SYNC` call from Google to a 3p partner's home control agent for
  ## a user.
  ## 
  ## 
  ## The third-party user's identity is passed in as `agent_user_id`
  ## (see RequestSyncDevicesRequest) and forwarded back to the agent.
  ## The agent is identified by the API key or JWT signed by the partner's
  ## service account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578920 = newJObject()
  var body_578921 = newJObject()
  add(query_578920, "key", newJString(key))
  add(query_578920, "prettyPrint", newJBool(prettyPrint))
  add(query_578920, "oauth_token", newJString(oauthToken))
  add(query_578920, "$.xgafv", newJString(Xgafv))
  add(query_578920, "alt", newJString(alt))
  add(query_578920, "uploadType", newJString(uploadType))
  add(query_578920, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578921 = body
  add(query_578920, "callback", newJString(callback))
  add(query_578920, "fields", newJString(fields))
  add(query_578920, "access_token", newJString(accessToken))
  add(query_578920, "upload_protocol", newJString(uploadProtocol))
  result = call_578919.call(nil, query_578920, nil, nil, body_578921)

var homegraphDevicesRequestSync* = Call_HomegraphDevicesRequestSync_578903(
    name: "homegraphDevicesRequestSync", meth: HttpMethod.HttpPost,
    host: "homegraph.googleapis.com", route: "/v1/devices:requestSync",
    validator: validate_HomegraphDevicesRequestSync_578904, base: "/",
    url: url_HomegraphDevicesRequestSync_578905, schemes: {Scheme.Https})
type
  Call_HomegraphDevicesSync_578922 = ref object of OpenApiRestCall_578339
proc url_HomegraphDevicesSync_578924(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_HomegraphDevicesSync_578923(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578925 = query.getOrDefault("key")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "key", valid_578925
  var valid_578926 = query.getOrDefault("prettyPrint")
  valid_578926 = validateParameter(valid_578926, JBool, required = false,
                                 default = newJBool(true))
  if valid_578926 != nil:
    section.add "prettyPrint", valid_578926
  var valid_578927 = query.getOrDefault("oauth_token")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "oauth_token", valid_578927
  var valid_578928 = query.getOrDefault("$.xgafv")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = newJString("1"))
  if valid_578928 != nil:
    section.add "$.xgafv", valid_578928
  var valid_578929 = query.getOrDefault("alt")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = newJString("json"))
  if valid_578929 != nil:
    section.add "alt", valid_578929
  var valid_578930 = query.getOrDefault("uploadType")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "uploadType", valid_578930
  var valid_578931 = query.getOrDefault("quotaUser")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "quotaUser", valid_578931
  var valid_578932 = query.getOrDefault("callback")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "callback", valid_578932
  var valid_578933 = query.getOrDefault("fields")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "fields", valid_578933
  var valid_578934 = query.getOrDefault("access_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "access_token", valid_578934
  var valid_578935 = query.getOrDefault("upload_protocol")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "upload_protocol", valid_578935
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

proc call*(call_578937: Call_HomegraphDevicesSync_578922; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the devices associated with the given third-party user.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
  ## 
  let valid = call_578937.validator(path, query, header, formData, body)
  let scheme = call_578937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578937.url(scheme.get, call_578937.host, call_578937.base,
                         call_578937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578937, url, valid)

proc call*(call_578938: Call_HomegraphDevicesSync_578922; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## homegraphDevicesSync
  ## Gets all the devices associated with the given third-party user.
  ## The third-party user's identity is passed in as `agent_user_id`. The agent
  ## is identified by the JWT signed by the third-party partner's service
  ## account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578939 = newJObject()
  var body_578940 = newJObject()
  add(query_578939, "key", newJString(key))
  add(query_578939, "prettyPrint", newJBool(prettyPrint))
  add(query_578939, "oauth_token", newJString(oauthToken))
  add(query_578939, "$.xgafv", newJString(Xgafv))
  add(query_578939, "alt", newJString(alt))
  add(query_578939, "uploadType", newJString(uploadType))
  add(query_578939, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578940 = body
  add(query_578939, "callback", newJString(callback))
  add(query_578939, "fields", newJString(fields))
  add(query_578939, "access_token", newJString(accessToken))
  add(query_578939, "upload_protocol", newJString(uploadProtocol))
  result = call_578938.call(nil, query_578939, nil, nil, body_578940)

var homegraphDevicesSync* = Call_HomegraphDevicesSync_578922(
    name: "homegraphDevicesSync", meth: HttpMethod.HttpPost,
    host: "homegraph.googleapis.com", route: "/v1/devices:sync",
    validator: validate_HomegraphDevicesSync_578923, base: "/",
    url: url_HomegraphDevicesSync_578924, schemes: {Scheme.Https})
type
  Call_HomegraphAgentUsersDelete_578941 = ref object of OpenApiRestCall_578339
proc url_HomegraphAgentUsersDelete_578943(protocol: Scheme; host: string;
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

proc validate_HomegraphAgentUsersDelete_578942(path: JsonNode; query: JsonNode;
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
  var valid_578958 = path.getOrDefault("agentUserId")
  valid_578958 = validateParameter(valid_578958, JString, required = true,
                                 default = nil)
  if valid_578958 != nil:
    section.add "agentUserId", valid_578958
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   requestId: JString
  ##            : Request ID used for debugging.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578959 = query.getOrDefault("key")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "key", valid_578959
  var valid_578960 = query.getOrDefault("prettyPrint")
  valid_578960 = validateParameter(valid_578960, JBool, required = false,
                                 default = newJBool(true))
  if valid_578960 != nil:
    section.add "prettyPrint", valid_578960
  var valid_578961 = query.getOrDefault("oauth_token")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "oauth_token", valid_578961
  var valid_578962 = query.getOrDefault("$.xgafv")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = newJString("1"))
  if valid_578962 != nil:
    section.add "$.xgafv", valid_578962
  var valid_578963 = query.getOrDefault("alt")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("json"))
  if valid_578963 != nil:
    section.add "alt", valid_578963
  var valid_578964 = query.getOrDefault("uploadType")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "uploadType", valid_578964
  var valid_578965 = query.getOrDefault("quotaUser")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "quotaUser", valid_578965
  var valid_578966 = query.getOrDefault("callback")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "callback", valid_578966
  var valid_578967 = query.getOrDefault("requestId")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "requestId", valid_578967
  var valid_578968 = query.getOrDefault("fields")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "fields", valid_578968
  var valid_578969 = query.getOrDefault("access_token")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "access_token", valid_578969
  var valid_578970 = query.getOrDefault("upload_protocol")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "upload_protocol", valid_578970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578971: Call_HomegraphAgentUsersDelete_578941; path: JsonNode;
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
  let valid = call_578971.validator(path, query, header, formData, body)
  let scheme = call_578971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578971.url(scheme.get, call_578971.host, call_578971.base,
                         call_578971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578971, url, valid)

proc call*(call_578972: Call_HomegraphAgentUsersDelete_578941; agentUserId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; requestId: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   agentUserId: string (required)
  ##              : Required. Third-party user ID.
  ##   callback: string
  ##           : JSONP
  ##   requestId: string
  ##            : Request ID used for debugging.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578973 = newJObject()
  var query_578974 = newJObject()
  add(query_578974, "key", newJString(key))
  add(query_578974, "prettyPrint", newJBool(prettyPrint))
  add(query_578974, "oauth_token", newJString(oauthToken))
  add(query_578974, "$.xgafv", newJString(Xgafv))
  add(query_578974, "alt", newJString(alt))
  add(query_578974, "uploadType", newJString(uploadType))
  add(query_578974, "quotaUser", newJString(quotaUser))
  add(path_578973, "agentUserId", newJString(agentUserId))
  add(query_578974, "callback", newJString(callback))
  add(query_578974, "requestId", newJString(requestId))
  add(query_578974, "fields", newJString(fields))
  add(query_578974, "access_token", newJString(accessToken))
  add(query_578974, "upload_protocol", newJString(uploadProtocol))
  result = call_578972.call(path_578973, query_578974, nil, nil, nil)

var homegraphAgentUsersDelete* = Call_HomegraphAgentUsersDelete_578941(
    name: "homegraphAgentUsersDelete", meth: HttpMethod.HttpDelete,
    host: "homegraph.googleapis.com", route: "/v1/{agentUserId}",
    validator: validate_HomegraphAgentUsersDelete_578942, base: "/",
    url: url_HomegraphAgentUsersDelete_578943, schemes: {Scheme.Https})
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
