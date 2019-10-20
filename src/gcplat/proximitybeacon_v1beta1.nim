
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Proximity Beacon
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Registers, manages, indexes, and searches beacons.
## 
## https://developers.google.com/beacons/proximity/
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
  gcpServiceName = "proximitybeacon"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ProximitybeaconBeaconinfoGetforobserved_578610 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconinfoGetforobserved_578612(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconBeaconinfoGetforobserved_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Given one or more beacon observations, returns any beacon information
  ## and attachments accessible to your application. Authorize by using the
  ## [API
  ## key](https://developers.google.com/beacons/proximity/get-started#request_a_browser_api_key)
  ## for the application.
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

proc call*(call_578771: Call_ProximitybeaconBeaconinfoGetforobserved_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Given one or more beacon observations, returns any beacon information
  ## and attachments accessible to your application. Authorize by using the
  ## [API
  ## key](https://developers.google.com/beacons/proximity/get-started#request_a_browser_api_key)
  ## for the application.
  ## 
  let valid = call_578771.validator(path, query, header, formData, body)
  let scheme = call_578771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578771.url(scheme.get, call_578771.host, call_578771.base,
                         call_578771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578771, url, valid)

proc call*(call_578842: Call_ProximitybeaconBeaconinfoGetforobserved_578610;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## proximitybeaconBeaconinfoGetforobserved
  ## Given one or more beacon observations, returns any beacon information
  ## and attachments accessible to your application. Authorize by using the
  ## [API
  ## key](https://developers.google.com/beacons/proximity/get-started#request_a_browser_api_key)
  ## for the application.
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

var proximitybeaconBeaconinfoGetforobserved* = Call_ProximitybeaconBeaconinfoGetforobserved_578610(
    name: "proximitybeaconBeaconinfoGetforobserved", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/beaconinfo:getforobserved",
    validator: validate_ProximitybeaconBeaconinfoGetforobserved_578611, base: "/",
    url: url_ProximitybeaconBeaconinfoGetforobserved_578612,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsList_578884 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsList_578886(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconBeaconsList_578885(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches the beacon registry for beacons that match the given search
  ## criteria. Only those beacons that the client has permission to list
  ## will be returned.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
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
  ##   q: JString
  ##    : Filter query string that supports the following field filters:
  ## 
  ## * **description:`"<string>"`**
  ##   For example: **description:"Room 3"**
  ##   Returns beacons whose description matches tokens in the string "Room 3"
  ##   (not necessarily that exact string).
  ##   The string must be double-quoted.
  ## * **status:`<enum>`**
  ##   For example: **status:active**
  ##   Returns beacons whose status matches the given value. Values must be
  ##   one of the Beacon.Status enum values (case insensitive). Accepts
  ##   multiple filters which will be combined with OR logic.
  ## * **stability:`<enum>`**
  ##   For example: **stability:mobile**
  ##   Returns beacons whose expected stability matches the given value.
  ##   Values must be one of the Beacon.Stability enum values (case
  ##   insensitive). Accepts multiple filters which will be combined with
  ##   OR logic.
  ## * **place\_id:`"<string>"`**
  ##   For example: **place\_id:"ChIJVSZzVR8FdkgRXGmmm6SslKw="**
  ##   Returns beacons explicitly registered at the given place, expressed as
  ##   a Place ID obtained from [Google Places API](/places/place-id). Does not
  ##   match places inside the given place. Does not consider the beacon's
  ##   actual location (which may be different from its registered place).
  ##   Accepts multiple filters that will be combined with OR logic. The place
  ##   ID must be double-quoted.
  ## * **registration\_time`[<|>|<=|>=]<integer>`**
  ##   For example: **registration\_time>=1433116800**
  ##   Returns beacons whose registration time matches the given filter.
  ##   Supports the operators: <, >, <=, and >=. Timestamp must be expressed as
  ##   an integer number of seconds since midnight January 1, 1970 UTC. Accepts
  ##   at most two filters that will be combined with AND logic, to support
  ##   "between" semantics. If more than two are supplied, the latter ones are
  ##   ignored.
  ## * **lat:`<double> lng:<double> radius:<integer>`**
  ##   For example: **lat:51.1232343 lng:-1.093852 radius:1000**
  ##   Returns beacons whose registered location is within the given circle.
  ##   When any of these fields are given, all are required. Latitude and
  ##   longitude must be decimal degrees between -90.0 and 90.0 and between
  ##   -180.0 and 180.0 respectively. Radius must be an integer number of
  ##   meters between 10 and 1,000,000 (1000 km).
  ## * **property:`"<string>=<string>"`**
  ##   For example: **property:"battery-type=CR2032"**
  ##   Returns beacons which have a property of the given name and value.
  ##   Supports multiple filters which will be combined with OR logic.
  ##   The entire name=value string must be double-quoted as one string.
  ## * **attachment\_type:`"<string>"`**
  ##   For example: **attachment_type:"my-namespace/my-type"**
  ##   Returns beacons having at least one attachment of the given namespaced
  ##   type. Supports "any within this namespace" via the partial wildcard
  ##   syntax: "my-namespace/*". Supports multiple filters which will be
  ##   combined with OR logic. The string must be double-quoted.
  ## * **indoor\_level:`"<string>"`**
  ##   For example: **indoor\_level:"1"**
  ##   Returns beacons which are located on the given indoor level. Accepts
  ##   multiple filters that will be combined with OR logic.
  ## 
  ## Multiple filters on the same field are combined with OR logic (except
  ## registration_time which is combined with AND logic).
  ## Multiple filters on different fields are combined with AND logic.
  ## Filters should be separated by spaces.
  ## 
  ## As with any HTTP query string parameter, the whole filter expression must
  ## be URL-encoded.
  ## 
  ## Example REST request:
  ## `GET
  ## /v1beta1/beacons?q=status:active%20lat:51.123%20lng:-1.095%20radius:1000`
  ##   pageSize: JInt
  ##           : The maximum number of records to return for this request, up to a
  ## server-defined upper limit.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A pagination token obtained from a previous request to list beacons.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : The project id to list beacons under. If not present then the project
  ## credential that made the request is used as the project.
  ## Optional.
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
  var valid_578891 = query.getOrDefault("q")
  valid_578891 = validateParameter(valid_578891, JString, required = false,
                                 default = nil)
  if valid_578891 != nil:
    section.add "q", valid_578891
  var valid_578892 = query.getOrDefault("pageSize")
  valid_578892 = validateParameter(valid_578892, JInt, required = false, default = nil)
  if valid_578892 != nil:
    section.add "pageSize", valid_578892
  var valid_578893 = query.getOrDefault("alt")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = newJString("json"))
  if valid_578893 != nil:
    section.add "alt", valid_578893
  var valid_578894 = query.getOrDefault("uploadType")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "uploadType", valid_578894
  var valid_578895 = query.getOrDefault("quotaUser")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "quotaUser", valid_578895
  var valid_578896 = query.getOrDefault("pageToken")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "pageToken", valid_578896
  var valid_578897 = query.getOrDefault("callback")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "callback", valid_578897
  var valid_578898 = query.getOrDefault("fields")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "fields", valid_578898
  var valid_578899 = query.getOrDefault("access_token")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "access_token", valid_578899
  var valid_578900 = query.getOrDefault("upload_protocol")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "upload_protocol", valid_578900
  var valid_578901 = query.getOrDefault("projectId")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "projectId", valid_578901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578902: Call_ProximitybeaconBeaconsList_578884; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches the beacon registry for beacons that match the given search
  ## criteria. Only those beacons that the client has permission to list
  ## will be returned.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  let valid = call_578902.validator(path, query, header, formData, body)
  let scheme = call_578902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578902.url(scheme.get, call_578902.host, call_578902.base,
                         call_578902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578902, url, valid)

proc call*(call_578903: Call_ProximitybeaconBeaconsList_578884; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          q: string = ""; pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsList
  ## Searches the beacon registry for beacons that match the given search
  ## criteria. Only those beacons that the client has permission to list
  ## will be returned.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   q: string
  ##    : Filter query string that supports the following field filters:
  ## 
  ## * **description:`"<string>"`**
  ##   For example: **description:"Room 3"**
  ##   Returns beacons whose description matches tokens in the string "Room 3"
  ##   (not necessarily that exact string).
  ##   The string must be double-quoted.
  ## * **status:`<enum>`**
  ##   For example: **status:active**
  ##   Returns beacons whose status matches the given value. Values must be
  ##   one of the Beacon.Status enum values (case insensitive). Accepts
  ##   multiple filters which will be combined with OR logic.
  ## * **stability:`<enum>`**
  ##   For example: **stability:mobile**
  ##   Returns beacons whose expected stability matches the given value.
  ##   Values must be one of the Beacon.Stability enum values (case
  ##   insensitive). Accepts multiple filters which will be combined with
  ##   OR logic.
  ## * **place\_id:`"<string>"`**
  ##   For example: **place\_id:"ChIJVSZzVR8FdkgRXGmmm6SslKw="**
  ##   Returns beacons explicitly registered at the given place, expressed as
  ##   a Place ID obtained from [Google Places API](/places/place-id). Does not
  ##   match places inside the given place. Does not consider the beacon's
  ##   actual location (which may be different from its registered place).
  ##   Accepts multiple filters that will be combined with OR logic. The place
  ##   ID must be double-quoted.
  ## * **registration\_time`[<|>|<=|>=]<integer>`**
  ##   For example: **registration\_time>=1433116800**
  ##   Returns beacons whose registration time matches the given filter.
  ##   Supports the operators: <, >, <=, and >=. Timestamp must be expressed as
  ##   an integer number of seconds since midnight January 1, 1970 UTC. Accepts
  ##   at most two filters that will be combined with AND logic, to support
  ##   "between" semantics. If more than two are supplied, the latter ones are
  ##   ignored.
  ## * **lat:`<double> lng:<double> radius:<integer>`**
  ##   For example: **lat:51.1232343 lng:-1.093852 radius:1000**
  ##   Returns beacons whose registered location is within the given circle.
  ##   When any of these fields are given, all are required. Latitude and
  ##   longitude must be decimal degrees between -90.0 and 90.0 and between
  ##   -180.0 and 180.0 respectively. Radius must be an integer number of
  ##   meters between 10 and 1,000,000 (1000 km).
  ## * **property:`"<string>=<string>"`**
  ##   For example: **property:"battery-type=CR2032"**
  ##   Returns beacons which have a property of the given name and value.
  ##   Supports multiple filters which will be combined with OR logic.
  ##   The entire name=value string must be double-quoted as one string.
  ## * **attachment\_type:`"<string>"`**
  ##   For example: **attachment_type:"my-namespace/my-type"**
  ##   Returns beacons having at least one attachment of the given namespaced
  ##   type. Supports "any within this namespace" via the partial wildcard
  ##   syntax: "my-namespace/*". Supports multiple filters which will be
  ##   combined with OR logic. The string must be double-quoted.
  ## * **indoor\_level:`"<string>"`**
  ##   For example: **indoor\_level:"1"**
  ##   Returns beacons which are located on the given indoor level. Accepts
  ##   multiple filters that will be combined with OR logic.
  ## 
  ## Multiple filters on the same field are combined with OR logic (except
  ## registration_time which is combined with AND logic).
  ## Multiple filters on different fields are combined with AND logic.
  ## Filters should be separated by spaces.
  ## 
  ## As with any HTTP query string parameter, the whole filter expression must
  ## be URL-encoded.
  ## 
  ## Example REST request:
  ## `GET
  ## /v1beta1/beacons?q=status:active%20lat:51.123%20lng:-1.095%20radius:1000`
  ##   pageSize: int
  ##           : The maximum number of records to return for this request, up to a
  ## server-defined upper limit.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A pagination token obtained from a previous request to list beacons.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : The project id to list beacons under. If not present then the project
  ## credential that made the request is used as the project.
  ## Optional.
  var query_578904 = newJObject()
  add(query_578904, "key", newJString(key))
  add(query_578904, "prettyPrint", newJBool(prettyPrint))
  add(query_578904, "oauth_token", newJString(oauthToken))
  add(query_578904, "$.xgafv", newJString(Xgafv))
  add(query_578904, "q", newJString(q))
  add(query_578904, "pageSize", newJInt(pageSize))
  add(query_578904, "alt", newJString(alt))
  add(query_578904, "uploadType", newJString(uploadType))
  add(query_578904, "quotaUser", newJString(quotaUser))
  add(query_578904, "pageToken", newJString(pageToken))
  add(query_578904, "callback", newJString(callback))
  add(query_578904, "fields", newJString(fields))
  add(query_578904, "access_token", newJString(accessToken))
  add(query_578904, "upload_protocol", newJString(uploadProtocol))
  add(query_578904, "projectId", newJString(projectId))
  result = call_578903.call(nil, query_578904, nil, nil, nil)

var proximitybeaconBeaconsList* = Call_ProximitybeaconBeaconsList_578884(
    name: "proximitybeaconBeaconsList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/beacons",
    validator: validate_ProximitybeaconBeaconsList_578885, base: "/",
    url: url_ProximitybeaconBeaconsList_578886, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsRegister_578905 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsRegister_578907(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconBeaconsRegister_578906(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Registers a previously unregistered beacon given its `advertisedId`.
  ## These IDs are unique within the system. An ID can be registered only once.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
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
  ##   projectId: JString
  ##            : The project id of the project the beacon will be registered to. If
  ## the project id is not specified then the project making the request
  ## is used.
  ## Optional.
  section = newJObject()
  var valid_578908 = query.getOrDefault("key")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "key", valid_578908
  var valid_578909 = query.getOrDefault("prettyPrint")
  valid_578909 = validateParameter(valid_578909, JBool, required = false,
                                 default = newJBool(true))
  if valid_578909 != nil:
    section.add "prettyPrint", valid_578909
  var valid_578910 = query.getOrDefault("oauth_token")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "oauth_token", valid_578910
  var valid_578911 = query.getOrDefault("$.xgafv")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = newJString("1"))
  if valid_578911 != nil:
    section.add "$.xgafv", valid_578911
  var valid_578912 = query.getOrDefault("alt")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = newJString("json"))
  if valid_578912 != nil:
    section.add "alt", valid_578912
  var valid_578913 = query.getOrDefault("uploadType")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "uploadType", valid_578913
  var valid_578914 = query.getOrDefault("quotaUser")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "quotaUser", valid_578914
  var valid_578915 = query.getOrDefault("callback")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "callback", valid_578915
  var valid_578916 = query.getOrDefault("fields")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "fields", valid_578916
  var valid_578917 = query.getOrDefault("access_token")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "access_token", valid_578917
  var valid_578918 = query.getOrDefault("upload_protocol")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "upload_protocol", valid_578918
  var valid_578919 = query.getOrDefault("projectId")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "projectId", valid_578919
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

proc call*(call_578921: Call_ProximitybeaconBeaconsRegister_578905; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a previously unregistered beacon given its `advertisedId`.
  ## These IDs are unique within the system. An ID can be registered only once.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_578921.validator(path, query, header, formData, body)
  let scheme = call_578921.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578921.url(scheme.get, call_578921.host, call_578921.base,
                         call_578921.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578921, url, valid)

proc call*(call_578922: Call_ProximitybeaconBeaconsRegister_578905;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsRegister
  ## Registers a previously unregistered beacon given its `advertisedId`.
  ## These IDs are unique within the system. An ID can be registered only once.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
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
  ##   projectId: string
  ##            : The project id of the project the beacon will be registered to. If
  ## the project id is not specified then the project making the request
  ## is used.
  ## Optional.
  var query_578923 = newJObject()
  var body_578924 = newJObject()
  add(query_578923, "key", newJString(key))
  add(query_578923, "prettyPrint", newJBool(prettyPrint))
  add(query_578923, "oauth_token", newJString(oauthToken))
  add(query_578923, "$.xgafv", newJString(Xgafv))
  add(query_578923, "alt", newJString(alt))
  add(query_578923, "uploadType", newJString(uploadType))
  add(query_578923, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578924 = body
  add(query_578923, "callback", newJString(callback))
  add(query_578923, "fields", newJString(fields))
  add(query_578923, "access_token", newJString(accessToken))
  add(query_578923, "upload_protocol", newJString(uploadProtocol))
  add(query_578923, "projectId", newJString(projectId))
  result = call_578922.call(nil, query_578923, nil, nil, body_578924)

var proximitybeaconBeaconsRegister* = Call_ProximitybeaconBeaconsRegister_578905(
    name: "proximitybeaconBeaconsRegister", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/beacons:register",
    validator: validate_ProximitybeaconBeaconsRegister_578906, base: "/",
    url: url_ProximitybeaconBeaconsRegister_578907, schemes: {Scheme.Https})
type
  Call_ProximitybeaconGetEidparams_578925 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconGetEidparams_578927(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconGetEidparams_578926(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Proximity Beacon API's current public key and associated
  ## parameters used to initiate the Diffie-Hellman key exchange required to
  ## register a beacon that broadcasts the Eddystone-EID format. This key
  ## changes periodically; clients may cache it and re-use the same public key
  ## to provision and register multiple beacons. However, clients should be
  ## prepared to refresh this key when they encounter an error registering an
  ## Eddystone-EID beacon.
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
  var valid_578928 = query.getOrDefault("key")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "key", valid_578928
  var valid_578929 = query.getOrDefault("prettyPrint")
  valid_578929 = validateParameter(valid_578929, JBool, required = false,
                                 default = newJBool(true))
  if valid_578929 != nil:
    section.add "prettyPrint", valid_578929
  var valid_578930 = query.getOrDefault("oauth_token")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "oauth_token", valid_578930
  var valid_578931 = query.getOrDefault("$.xgafv")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = newJString("1"))
  if valid_578931 != nil:
    section.add "$.xgafv", valid_578931
  var valid_578932 = query.getOrDefault("alt")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = newJString("json"))
  if valid_578932 != nil:
    section.add "alt", valid_578932
  var valid_578933 = query.getOrDefault("uploadType")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "uploadType", valid_578933
  var valid_578934 = query.getOrDefault("quotaUser")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "quotaUser", valid_578934
  var valid_578935 = query.getOrDefault("callback")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "callback", valid_578935
  var valid_578936 = query.getOrDefault("fields")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "fields", valid_578936
  var valid_578937 = query.getOrDefault("access_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "access_token", valid_578937
  var valid_578938 = query.getOrDefault("upload_protocol")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "upload_protocol", valid_578938
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578939: Call_ProximitybeaconGetEidparams_578925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Proximity Beacon API's current public key and associated
  ## parameters used to initiate the Diffie-Hellman key exchange required to
  ## register a beacon that broadcasts the Eddystone-EID format. This key
  ## changes periodically; clients may cache it and re-use the same public key
  ## to provision and register multiple beacons. However, clients should be
  ## prepared to refresh this key when they encounter an error registering an
  ## Eddystone-EID beacon.
  ## 
  let valid = call_578939.validator(path, query, header, formData, body)
  let scheme = call_578939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578939.url(scheme.get, call_578939.host, call_578939.base,
                         call_578939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578939, url, valid)

proc call*(call_578940: Call_ProximitybeaconGetEidparams_578925; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## proximitybeaconGetEidparams
  ## Gets the Proximity Beacon API's current public key and associated
  ## parameters used to initiate the Diffie-Hellman key exchange required to
  ## register a beacon that broadcasts the Eddystone-EID format. This key
  ## changes periodically; clients may cache it and re-use the same public key
  ## to provision and register multiple beacons. However, clients should be
  ## prepared to refresh this key when they encounter an error registering an
  ## Eddystone-EID beacon.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578941 = newJObject()
  add(query_578941, "key", newJString(key))
  add(query_578941, "prettyPrint", newJBool(prettyPrint))
  add(query_578941, "oauth_token", newJString(oauthToken))
  add(query_578941, "$.xgafv", newJString(Xgafv))
  add(query_578941, "alt", newJString(alt))
  add(query_578941, "uploadType", newJString(uploadType))
  add(query_578941, "quotaUser", newJString(quotaUser))
  add(query_578941, "callback", newJString(callback))
  add(query_578941, "fields", newJString(fields))
  add(query_578941, "access_token", newJString(accessToken))
  add(query_578941, "upload_protocol", newJString(uploadProtocol))
  result = call_578940.call(nil, query_578941, nil, nil, nil)

var proximitybeaconGetEidparams* = Call_ProximitybeaconGetEidparams_578925(
    name: "proximitybeaconGetEidparams", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/eidparams",
    validator: validate_ProximitybeaconGetEidparams_578926, base: "/",
    url: url_ProximitybeaconGetEidparams_578927, schemes: {Scheme.Https})
type
  Call_ProximitybeaconNamespacesList_578942 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconNamespacesList_578944(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ProximitybeaconNamespacesList_578943(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all attachment namespaces owned by your Google Developers Console
  ## project. Attachment data associated with a beacon must include a
  ## namespaced type, and the namespace must be owned by your project.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
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
  ##   projectId: JString
  ##            : The project id to list namespaces under.
  ## Optional.
  section = newJObject()
  var valid_578945 = query.getOrDefault("key")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "key", valid_578945
  var valid_578946 = query.getOrDefault("prettyPrint")
  valid_578946 = validateParameter(valid_578946, JBool, required = false,
                                 default = newJBool(true))
  if valid_578946 != nil:
    section.add "prettyPrint", valid_578946
  var valid_578947 = query.getOrDefault("oauth_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "oauth_token", valid_578947
  var valid_578948 = query.getOrDefault("$.xgafv")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("1"))
  if valid_578948 != nil:
    section.add "$.xgafv", valid_578948
  var valid_578949 = query.getOrDefault("alt")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("json"))
  if valid_578949 != nil:
    section.add "alt", valid_578949
  var valid_578950 = query.getOrDefault("uploadType")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "uploadType", valid_578950
  var valid_578951 = query.getOrDefault("quotaUser")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "quotaUser", valid_578951
  var valid_578952 = query.getOrDefault("callback")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "callback", valid_578952
  var valid_578953 = query.getOrDefault("fields")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "fields", valid_578953
  var valid_578954 = query.getOrDefault("access_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "access_token", valid_578954
  var valid_578955 = query.getOrDefault("upload_protocol")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "upload_protocol", valid_578955
  var valid_578956 = query.getOrDefault("projectId")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "projectId", valid_578956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578957: Call_ProximitybeaconNamespacesList_578942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all attachment namespaces owned by your Google Developers Console
  ## project. Attachment data associated with a beacon must include a
  ## namespaced type, and the namespace must be owned by your project.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  let valid = call_578957.validator(path, query, header, formData, body)
  let scheme = call_578957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578957.url(scheme.get, call_578957.host, call_578957.base,
                         call_578957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578957, url, valid)

proc call*(call_578958: Call_ProximitybeaconNamespacesList_578942;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## proximitybeaconNamespacesList
  ## Lists all attachment namespaces owned by your Google Developers Console
  ## project. Attachment data associated with a beacon must include a
  ## namespaced type, and the namespace must be owned by your project.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : The project id to list namespaces under.
  ## Optional.
  var query_578959 = newJObject()
  add(query_578959, "key", newJString(key))
  add(query_578959, "prettyPrint", newJBool(prettyPrint))
  add(query_578959, "oauth_token", newJString(oauthToken))
  add(query_578959, "$.xgafv", newJString(Xgafv))
  add(query_578959, "alt", newJString(alt))
  add(query_578959, "uploadType", newJString(uploadType))
  add(query_578959, "quotaUser", newJString(quotaUser))
  add(query_578959, "callback", newJString(callback))
  add(query_578959, "fields", newJString(fields))
  add(query_578959, "access_token", newJString(accessToken))
  add(query_578959, "upload_protocol", newJString(uploadProtocol))
  add(query_578959, "projectId", newJString(projectId))
  result = call_578958.call(nil, query_578959, nil, nil, nil)

var proximitybeaconNamespacesList* = Call_ProximitybeaconNamespacesList_578942(
    name: "proximitybeaconNamespacesList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/namespaces",
    validator: validate_ProximitybeaconNamespacesList_578943, base: "/",
    url: url_ProximitybeaconNamespacesList_578944, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsDelete_578960 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsAttachmentsDelete_578962(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "attachmentName" in path, "`attachmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "attachmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsDelete_578961(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified attachment for the given beacon. Each attachment has
  ## a unique attachment name (`attachmentName`) which is returned when you
  ## fetch the attachment data via this API. You specify this with the delete
  ## request to control which attachment is removed. This operation cannot be
  ## undone.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   attachmentName: JString (required)
  ##                 : The attachment name (`attachmentName`) of
  ## the attachment to remove. For example:
  ## `beacons/3!893737abc9/attachments/c5e937-af0-494-959-ec49d12738`. For
  ## Eddystone-EID beacons, the beacon ID portion (`3!893737abc9`) may be the
  ## beacon's current EID, or its "stable" Eddystone-UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `attachmentName` field"
  var valid_578977 = path.getOrDefault("attachmentName")
  valid_578977 = validateParameter(valid_578977, JString, required = true,
                                 default = nil)
  if valid_578977 != nil:
    section.add "attachmentName", valid_578977
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
  ##   projectId: JString
  ##            : The project id of the attachment to delete. If not provided, the project
  ## that is making the request is used.
  ## Optional.
  section = newJObject()
  var valid_578978 = query.getOrDefault("key")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "key", valid_578978
  var valid_578979 = query.getOrDefault("prettyPrint")
  valid_578979 = validateParameter(valid_578979, JBool, required = false,
                                 default = newJBool(true))
  if valid_578979 != nil:
    section.add "prettyPrint", valid_578979
  var valid_578980 = query.getOrDefault("oauth_token")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "oauth_token", valid_578980
  var valid_578981 = query.getOrDefault("$.xgafv")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = newJString("1"))
  if valid_578981 != nil:
    section.add "$.xgafv", valid_578981
  var valid_578982 = query.getOrDefault("alt")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = newJString("json"))
  if valid_578982 != nil:
    section.add "alt", valid_578982
  var valid_578983 = query.getOrDefault("uploadType")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "uploadType", valid_578983
  var valid_578984 = query.getOrDefault("quotaUser")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "quotaUser", valid_578984
  var valid_578985 = query.getOrDefault("callback")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "callback", valid_578985
  var valid_578986 = query.getOrDefault("fields")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "fields", valid_578986
  var valid_578987 = query.getOrDefault("access_token")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "access_token", valid_578987
  var valid_578988 = query.getOrDefault("upload_protocol")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "upload_protocol", valid_578988
  var valid_578989 = query.getOrDefault("projectId")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "projectId", valid_578989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578990: Call_ProximitybeaconBeaconsAttachmentsDelete_578960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified attachment for the given beacon. Each attachment has
  ## a unique attachment name (`attachmentName`) which is returned when you
  ## fetch the attachment data via this API. You specify this with the delete
  ## request to control which attachment is removed. This operation cannot be
  ## undone.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_578990.validator(path, query, header, formData, body)
  let scheme = call_578990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578990.url(scheme.get, call_578990.host, call_578990.base,
                         call_578990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578990, url, valid)

proc call*(call_578991: Call_ProximitybeaconBeaconsAttachmentsDelete_578960;
          attachmentName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsAttachmentsDelete
  ## Deletes the specified attachment for the given beacon. Each attachment has
  ## a unique attachment name (`attachmentName`) which is returned when you
  ## fetch the attachment data via this API. You specify this with the delete
  ## request to control which attachment is removed. This operation cannot be
  ## undone.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
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
  ##   attachmentName: string (required)
  ##                 : The attachment name (`attachmentName`) of
  ## the attachment to remove. For example:
  ## `beacons/3!893737abc9/attachments/c5e937-af0-494-959-ec49d12738`. For
  ## Eddystone-EID beacons, the beacon ID portion (`3!893737abc9`) may be the
  ## beacon's current EID, or its "stable" Eddystone-UID.
  ## Required.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : The project id of the attachment to delete. If not provided, the project
  ## that is making the request is used.
  ## Optional.
  var path_578992 = newJObject()
  var query_578993 = newJObject()
  add(query_578993, "key", newJString(key))
  add(query_578993, "prettyPrint", newJBool(prettyPrint))
  add(query_578993, "oauth_token", newJString(oauthToken))
  add(query_578993, "$.xgafv", newJString(Xgafv))
  add(query_578993, "alt", newJString(alt))
  add(query_578993, "uploadType", newJString(uploadType))
  add(query_578993, "quotaUser", newJString(quotaUser))
  add(path_578992, "attachmentName", newJString(attachmentName))
  add(query_578993, "callback", newJString(callback))
  add(query_578993, "fields", newJString(fields))
  add(query_578993, "access_token", newJString(accessToken))
  add(query_578993, "upload_protocol", newJString(uploadProtocol))
  add(query_578993, "projectId", newJString(projectId))
  result = call_578991.call(path_578992, query_578993, nil, nil, nil)

var proximitybeaconBeaconsAttachmentsDelete* = Call_ProximitybeaconBeaconsAttachmentsDelete_578960(
    name: "proximitybeaconBeaconsAttachmentsDelete", meth: HttpMethod.HttpDelete,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{attachmentName}",
    validator: validate_ProximitybeaconBeaconsAttachmentsDelete_578961, base: "/",
    url: url_ProximitybeaconBeaconsAttachmentsDelete_578962,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsUpdate_579014 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsUpdate_579016(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsUpdate_579015(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the information about the specified beacon. **Any field that you do
  ## not populate in the submitted beacon will be permanently erased**, so you
  ## should follow the "read, modify, write" pattern to avoid inadvertently
  ## destroying data.
  ## 
  ## Changes to the beacon status via this method will be  silently ignored.
  ## To update beacon status, use the separate methods on this API for
  ## activation, deactivation, and decommissioning.
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Resource name of this beacon. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone, `1` for iBeacon, or `5` for AltBeacon.
  ## 
  ## This field must be left empty when registering. After reading a beacon,
  ## clients can use the name for future operations.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_579017 = path.getOrDefault("beaconName")
  valid_579017 = validateParameter(valid_579017, JString, required = true,
                                 default = nil)
  if valid_579017 != nil:
    section.add "beaconName", valid_579017
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
  ##   projectId: JString
  ##            : The project id of the beacon to update. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  section = newJObject()
  var valid_579018 = query.getOrDefault("key")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "key", valid_579018
  var valid_579019 = query.getOrDefault("prettyPrint")
  valid_579019 = validateParameter(valid_579019, JBool, required = false,
                                 default = newJBool(true))
  if valid_579019 != nil:
    section.add "prettyPrint", valid_579019
  var valid_579020 = query.getOrDefault("oauth_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "oauth_token", valid_579020
  var valid_579021 = query.getOrDefault("$.xgafv")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("1"))
  if valid_579021 != nil:
    section.add "$.xgafv", valid_579021
  var valid_579022 = query.getOrDefault("alt")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = newJString("json"))
  if valid_579022 != nil:
    section.add "alt", valid_579022
  var valid_579023 = query.getOrDefault("uploadType")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "uploadType", valid_579023
  var valid_579024 = query.getOrDefault("quotaUser")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "quotaUser", valid_579024
  var valid_579025 = query.getOrDefault("callback")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "callback", valid_579025
  var valid_579026 = query.getOrDefault("fields")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "fields", valid_579026
  var valid_579027 = query.getOrDefault("access_token")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "access_token", valid_579027
  var valid_579028 = query.getOrDefault("upload_protocol")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "upload_protocol", valid_579028
  var valid_579029 = query.getOrDefault("projectId")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "projectId", valid_579029
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

proc call*(call_579031: Call_ProximitybeaconBeaconsUpdate_579014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the information about the specified beacon. **Any field that you do
  ## not populate in the submitted beacon will be permanently erased**, so you
  ## should follow the "read, modify, write" pattern to avoid inadvertently
  ## destroying data.
  ## 
  ## Changes to the beacon status via this method will be  silently ignored.
  ## To update beacon status, use the separate methods on this API for
  ## activation, deactivation, and decommissioning.
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_579031.validator(path, query, header, formData, body)
  let scheme = call_579031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579031.url(scheme.get, call_579031.host, call_579031.base,
                         call_579031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579031, url, valid)

proc call*(call_579032: Call_ProximitybeaconBeaconsUpdate_579014;
          beaconName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsUpdate
  ## Updates the information about the specified beacon. **Any field that you do
  ## not populate in the submitted beacon will be permanently erased**, so you
  ## should follow the "read, modify, write" pattern to avoid inadvertently
  ## destroying data.
  ## 
  ## Changes to the beacon status via this method will be  silently ignored.
  ## To update beacon status, use the separate methods on this API for
  ## activation, deactivation, and decommissioning.
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
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
  ##   beaconName: string (required)
  ##             : Resource name of this beacon. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone, `1` for iBeacon, or `5` for AltBeacon.
  ## 
  ## This field must be left empty when registering. After reading a beacon,
  ## clients can use the name for future operations.
  ##   projectId: string
  ##            : The project id of the beacon to update. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  var path_579033 = newJObject()
  var query_579034 = newJObject()
  var body_579035 = newJObject()
  add(query_579034, "key", newJString(key))
  add(query_579034, "prettyPrint", newJBool(prettyPrint))
  add(query_579034, "oauth_token", newJString(oauthToken))
  add(query_579034, "$.xgafv", newJString(Xgafv))
  add(query_579034, "alt", newJString(alt))
  add(query_579034, "uploadType", newJString(uploadType))
  add(query_579034, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579035 = body
  add(query_579034, "callback", newJString(callback))
  add(query_579034, "fields", newJString(fields))
  add(query_579034, "access_token", newJString(accessToken))
  add(query_579034, "upload_protocol", newJString(uploadProtocol))
  add(path_579033, "beaconName", newJString(beaconName))
  add(query_579034, "projectId", newJString(projectId))
  result = call_579032.call(path_579033, query_579034, nil, nil, body_579035)

var proximitybeaconBeaconsUpdate* = Call_ProximitybeaconBeaconsUpdate_579014(
    name: "proximitybeaconBeaconsUpdate", meth: HttpMethod.HttpPut,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{beaconName}",
    validator: validate_ProximitybeaconBeaconsUpdate_579015, base: "/",
    url: url_ProximitybeaconBeaconsUpdate_579016, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsGet_578994 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsGet_578996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsGet_578995(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns detailed information about the specified beacon.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  ## Requests may supply an Eddystone-EID beacon name in the form:
  ## `beacons/4!beaconId` where the `beaconId` is the base16 ephemeral ID
  ## broadcast by the beacon. The returned `Beacon` object will contain the
  ## beacon's stable Eddystone-UID. Clients not authorized to resolve the
  ## beacon's ephemeral Eddystone-EID broadcast will receive an error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Resource name of this beacon. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_578997 = path.getOrDefault("beaconName")
  valid_578997 = validateParameter(valid_578997, JString, required = true,
                                 default = nil)
  if valid_578997 != nil:
    section.add "beaconName", valid_578997
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
  ##   projectId: JString
  ##            : The project id of the beacon to request. If the project id is not specified
  ## then the project making the request is used. The project id must match the
  ## project that owns the beacon.
  ## Optional.
  section = newJObject()
  var valid_578998 = query.getOrDefault("key")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "key", valid_578998
  var valid_578999 = query.getOrDefault("prettyPrint")
  valid_578999 = validateParameter(valid_578999, JBool, required = false,
                                 default = newJBool(true))
  if valid_578999 != nil:
    section.add "prettyPrint", valid_578999
  var valid_579000 = query.getOrDefault("oauth_token")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "oauth_token", valid_579000
  var valid_579001 = query.getOrDefault("$.xgafv")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("1"))
  if valid_579001 != nil:
    section.add "$.xgafv", valid_579001
  var valid_579002 = query.getOrDefault("alt")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = newJString("json"))
  if valid_579002 != nil:
    section.add "alt", valid_579002
  var valid_579003 = query.getOrDefault("uploadType")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "uploadType", valid_579003
  var valid_579004 = query.getOrDefault("quotaUser")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "quotaUser", valid_579004
  var valid_579005 = query.getOrDefault("callback")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "callback", valid_579005
  var valid_579006 = query.getOrDefault("fields")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "fields", valid_579006
  var valid_579007 = query.getOrDefault("access_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "access_token", valid_579007
  var valid_579008 = query.getOrDefault("upload_protocol")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "upload_protocol", valid_579008
  var valid_579009 = query.getOrDefault("projectId")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "projectId", valid_579009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579010: Call_ProximitybeaconBeaconsGet_578994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns detailed information about the specified beacon.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  ## Requests may supply an Eddystone-EID beacon name in the form:
  ## `beacons/4!beaconId` where the `beaconId` is the base16 ephemeral ID
  ## broadcast by the beacon. The returned `Beacon` object will contain the
  ## beacon's stable Eddystone-UID. Clients not authorized to resolve the
  ## beacon's ephemeral Eddystone-EID broadcast will receive an error.
  ## 
  let valid = call_579010.validator(path, query, header, formData, body)
  let scheme = call_579010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579010.url(scheme.get, call_579010.host, call_579010.base,
                         call_579010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579010, url, valid)

proc call*(call_579011: Call_ProximitybeaconBeaconsGet_578994; beaconName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsGet
  ## Returns detailed information about the specified beacon.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  ## Requests may supply an Eddystone-EID beacon name in the form:
  ## `beacons/4!beaconId` where the `beaconId` is the base16 ephemeral ID
  ## broadcast by the beacon. The returned `Beacon` object will contain the
  ## beacon's stable Eddystone-UID. Clients not authorized to resolve the
  ## beacon's ephemeral Eddystone-EID broadcast will receive an error.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   beaconName: string (required)
  ##             : Resource name of this beacon. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   projectId: string
  ##            : The project id of the beacon to request. If the project id is not specified
  ## then the project making the request is used. The project id must match the
  ## project that owns the beacon.
  ## Optional.
  var path_579012 = newJObject()
  var query_579013 = newJObject()
  add(query_579013, "key", newJString(key))
  add(query_579013, "prettyPrint", newJBool(prettyPrint))
  add(query_579013, "oauth_token", newJString(oauthToken))
  add(query_579013, "$.xgafv", newJString(Xgafv))
  add(query_579013, "alt", newJString(alt))
  add(query_579013, "uploadType", newJString(uploadType))
  add(query_579013, "quotaUser", newJString(quotaUser))
  add(query_579013, "callback", newJString(callback))
  add(query_579013, "fields", newJString(fields))
  add(query_579013, "access_token", newJString(accessToken))
  add(query_579013, "upload_protocol", newJString(uploadProtocol))
  add(path_579012, "beaconName", newJString(beaconName))
  add(query_579013, "projectId", newJString(projectId))
  result = call_579011.call(path_579012, query_579013, nil, nil, nil)

var proximitybeaconBeaconsGet* = Call_ProximitybeaconBeaconsGet_578994(
    name: "proximitybeaconBeaconsGet", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{beaconName}",
    validator: validate_ProximitybeaconBeaconsGet_578995, base: "/",
    url: url_ProximitybeaconBeaconsGet_578996, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDelete_579036 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsDelete_579038(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDelete_579037(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified beacon including all diagnostics data for the beacon
  ## as well as any attachments on the beacon (including those belonging to
  ## other projects). This operation cannot be undone.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that should be deleted. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_579039 = path.getOrDefault("beaconName")
  valid_579039 = validateParameter(valid_579039, JString, required = true,
                                 default = nil)
  if valid_579039 != nil:
    section.add "beaconName", valid_579039
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
  ##   projectId: JString
  ##            : The project id of the beacon to delete. If not provided, the project
  ## that is making the request is used.
  ## Optional.
  section = newJObject()
  var valid_579040 = query.getOrDefault("key")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "key", valid_579040
  var valid_579041 = query.getOrDefault("prettyPrint")
  valid_579041 = validateParameter(valid_579041, JBool, required = false,
                                 default = newJBool(true))
  if valid_579041 != nil:
    section.add "prettyPrint", valid_579041
  var valid_579042 = query.getOrDefault("oauth_token")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "oauth_token", valid_579042
  var valid_579043 = query.getOrDefault("$.xgafv")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = newJString("1"))
  if valid_579043 != nil:
    section.add "$.xgafv", valid_579043
  var valid_579044 = query.getOrDefault("alt")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = newJString("json"))
  if valid_579044 != nil:
    section.add "alt", valid_579044
  var valid_579045 = query.getOrDefault("uploadType")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "uploadType", valid_579045
  var valid_579046 = query.getOrDefault("quotaUser")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "quotaUser", valid_579046
  var valid_579047 = query.getOrDefault("callback")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "callback", valid_579047
  var valid_579048 = query.getOrDefault("fields")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "fields", valid_579048
  var valid_579049 = query.getOrDefault("access_token")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "access_token", valid_579049
  var valid_579050 = query.getOrDefault("upload_protocol")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "upload_protocol", valid_579050
  var valid_579051 = query.getOrDefault("projectId")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "projectId", valid_579051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579052: Call_ProximitybeaconBeaconsDelete_579036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified beacon including all diagnostics data for the beacon
  ## as well as any attachments on the beacon (including those belonging to
  ## other projects). This operation cannot be undone.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_579052.validator(path, query, header, formData, body)
  let scheme = call_579052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579052.url(scheme.get, call_579052.host, call_579052.base,
                         call_579052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579052, url, valid)

proc call*(call_579053: Call_ProximitybeaconBeaconsDelete_579036;
          beaconName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsDelete
  ## Deletes the specified beacon including all diagnostics data for the beacon
  ## as well as any attachments on the beacon (including those belonging to
  ## other projects). This operation cannot be undone.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   beaconName: string (required)
  ##             : Beacon that should be deleted. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   projectId: string
  ##            : The project id of the beacon to delete. If not provided, the project
  ## that is making the request is used.
  ## Optional.
  var path_579054 = newJObject()
  var query_579055 = newJObject()
  add(query_579055, "key", newJString(key))
  add(query_579055, "prettyPrint", newJBool(prettyPrint))
  add(query_579055, "oauth_token", newJString(oauthToken))
  add(query_579055, "$.xgafv", newJString(Xgafv))
  add(query_579055, "alt", newJString(alt))
  add(query_579055, "uploadType", newJString(uploadType))
  add(query_579055, "quotaUser", newJString(quotaUser))
  add(query_579055, "callback", newJString(callback))
  add(query_579055, "fields", newJString(fields))
  add(query_579055, "access_token", newJString(accessToken))
  add(query_579055, "upload_protocol", newJString(uploadProtocol))
  add(path_579054, "beaconName", newJString(beaconName))
  add(query_579055, "projectId", newJString(projectId))
  result = call_579053.call(path_579054, query_579055, nil, nil, nil)

var proximitybeaconBeaconsDelete* = Call_ProximitybeaconBeaconsDelete_579036(
    name: "proximitybeaconBeaconsDelete", meth: HttpMethod.HttpDelete,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{beaconName}",
    validator: validate_ProximitybeaconBeaconsDelete_579037, base: "/",
    url: url_ProximitybeaconBeaconsDelete_579038, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsCreate_579077 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsAttachmentsCreate_579079(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: "/attachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsCreate_579078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Associates the given data with the specified beacon. Attachment data must
  ## contain two parts:
  ## <ul>
  ## <li>A namespaced type.</li>
  ## <li>The actual attachment data itself.</li>
  ## </ul>
  ## The namespaced type consists of two parts, the namespace and the type.
  ## The namespace must be one of the values returned by the `namespaces`
  ## endpoint, while the type can be a string of any characters except for the
  ## forward slash (`/`) up to 100 characters in length.
  ## 
  ## Attachment data can be up to 1024 bytes long.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon on which the attachment should be created. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_579080 = path.getOrDefault("beaconName")
  valid_579080 = validateParameter(valid_579080, JString, required = true,
                                 default = nil)
  if valid_579080 != nil:
    section.add "beaconName", valid_579080
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
  ##   projectId: JString
  ##            : The project id of the project the attachment will belong to. If
  ## the project id is not specified then the project making the request
  ## is used.
  ## Optional.
  section = newJObject()
  var valid_579081 = query.getOrDefault("key")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "key", valid_579081
  var valid_579082 = query.getOrDefault("prettyPrint")
  valid_579082 = validateParameter(valid_579082, JBool, required = false,
                                 default = newJBool(true))
  if valid_579082 != nil:
    section.add "prettyPrint", valid_579082
  var valid_579083 = query.getOrDefault("oauth_token")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "oauth_token", valid_579083
  var valid_579084 = query.getOrDefault("$.xgafv")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = newJString("1"))
  if valid_579084 != nil:
    section.add "$.xgafv", valid_579084
  var valid_579085 = query.getOrDefault("alt")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = newJString("json"))
  if valid_579085 != nil:
    section.add "alt", valid_579085
  var valid_579086 = query.getOrDefault("uploadType")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "uploadType", valid_579086
  var valid_579087 = query.getOrDefault("quotaUser")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "quotaUser", valid_579087
  var valid_579088 = query.getOrDefault("callback")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "callback", valid_579088
  var valid_579089 = query.getOrDefault("fields")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "fields", valid_579089
  var valid_579090 = query.getOrDefault("access_token")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "access_token", valid_579090
  var valid_579091 = query.getOrDefault("upload_protocol")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "upload_protocol", valid_579091
  var valid_579092 = query.getOrDefault("projectId")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "projectId", valid_579092
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

proc call*(call_579094: Call_ProximitybeaconBeaconsAttachmentsCreate_579077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associates the given data with the specified beacon. Attachment data must
  ## contain two parts:
  ## <ul>
  ## <li>A namespaced type.</li>
  ## <li>The actual attachment data itself.</li>
  ## </ul>
  ## The namespaced type consists of two parts, the namespace and the type.
  ## The namespace must be one of the values returned by the `namespaces`
  ## endpoint, while the type can be a string of any characters except for the
  ## forward slash (`/`) up to 100 characters in length.
  ## 
  ## Attachment data can be up to 1024 bytes long.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_579094.validator(path, query, header, formData, body)
  let scheme = call_579094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579094.url(scheme.get, call_579094.host, call_579094.base,
                         call_579094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579094, url, valid)

proc call*(call_579095: Call_ProximitybeaconBeaconsAttachmentsCreate_579077;
          beaconName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsAttachmentsCreate
  ## Associates the given data with the specified beacon. Attachment data must
  ## contain two parts:
  ## <ul>
  ## <li>A namespaced type.</li>
  ## <li>The actual attachment data itself.</li>
  ## </ul>
  ## The namespaced type consists of two parts, the namespace and the type.
  ## The namespace must be one of the values returned by the `namespaces`
  ## endpoint, while the type can be a string of any characters except for the
  ## forward slash (`/`) up to 100 characters in length.
  ## 
  ## Attachment data can be up to 1024 bytes long.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
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
  ##   beaconName: string (required)
  ##             : Beacon on which the attachment should be created. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   projectId: string
  ##            : The project id of the project the attachment will belong to. If
  ## the project id is not specified then the project making the request
  ## is used.
  ## Optional.
  var path_579096 = newJObject()
  var query_579097 = newJObject()
  var body_579098 = newJObject()
  add(query_579097, "key", newJString(key))
  add(query_579097, "prettyPrint", newJBool(prettyPrint))
  add(query_579097, "oauth_token", newJString(oauthToken))
  add(query_579097, "$.xgafv", newJString(Xgafv))
  add(query_579097, "alt", newJString(alt))
  add(query_579097, "uploadType", newJString(uploadType))
  add(query_579097, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579098 = body
  add(query_579097, "callback", newJString(callback))
  add(query_579097, "fields", newJString(fields))
  add(query_579097, "access_token", newJString(accessToken))
  add(query_579097, "upload_protocol", newJString(uploadProtocol))
  add(path_579096, "beaconName", newJString(beaconName))
  add(query_579097, "projectId", newJString(projectId))
  result = call_579095.call(path_579096, query_579097, nil, nil, body_579098)

var proximitybeaconBeaconsAttachmentsCreate* = Call_ProximitybeaconBeaconsAttachmentsCreate_579077(
    name: "proximitybeaconBeaconsAttachmentsCreate", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/attachments",
    validator: validate_ProximitybeaconBeaconsAttachmentsCreate_579078, base: "/",
    url: url_ProximitybeaconBeaconsAttachmentsCreate_579079,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsList_579056 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsAttachmentsList_579058(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: "/attachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsList_579057(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the attachments for the specified beacon that match the specified
  ## namespaced-type pattern.
  ## 
  ## To control which namespaced types are returned, you add the
  ## `namespacedType` query parameter to the request. You must either use
  ## `*/*`, to return all attachments, or the namespace must be one of
  ## the ones returned from the  `namespaces` endpoint.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon whose attachments should be fetched. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_579059 = path.getOrDefault("beaconName")
  valid_579059 = validateParameter(valid_579059, JString, required = true,
                                 default = nil)
  if valid_579059 != nil:
    section.add "beaconName", valid_579059
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
  ##   namespacedType: JString
  ##                 : Specifies the namespace and type of attachment to include in response in
  ## <var>namespace/type</var> format. Accepts `*/*` to specify
  ## "all types in all namespaces".
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : The project id to list beacon attachments under. This field can be
  ## used when "*" is specified to mean all attachment namespaces. Projects
  ## may have multiple attachments with multiple namespaces. If "*" is
  ## specified and the projectId string is empty, then the project
  ## making the request is used.
  ## Optional.
  section = newJObject()
  var valid_579060 = query.getOrDefault("key")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "key", valid_579060
  var valid_579061 = query.getOrDefault("prettyPrint")
  valid_579061 = validateParameter(valid_579061, JBool, required = false,
                                 default = newJBool(true))
  if valid_579061 != nil:
    section.add "prettyPrint", valid_579061
  var valid_579062 = query.getOrDefault("oauth_token")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "oauth_token", valid_579062
  var valid_579063 = query.getOrDefault("$.xgafv")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = newJString("1"))
  if valid_579063 != nil:
    section.add "$.xgafv", valid_579063
  var valid_579064 = query.getOrDefault("alt")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("json"))
  if valid_579064 != nil:
    section.add "alt", valid_579064
  var valid_579065 = query.getOrDefault("uploadType")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "uploadType", valid_579065
  var valid_579066 = query.getOrDefault("quotaUser")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "quotaUser", valid_579066
  var valid_579067 = query.getOrDefault("callback")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "callback", valid_579067
  var valid_579068 = query.getOrDefault("namespacedType")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "namespacedType", valid_579068
  var valid_579069 = query.getOrDefault("fields")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "fields", valid_579069
  var valid_579070 = query.getOrDefault("access_token")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "access_token", valid_579070
  var valid_579071 = query.getOrDefault("upload_protocol")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "upload_protocol", valid_579071
  var valid_579072 = query.getOrDefault("projectId")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "projectId", valid_579072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579073: Call_ProximitybeaconBeaconsAttachmentsList_579056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the attachments for the specified beacon that match the specified
  ## namespaced-type pattern.
  ## 
  ## To control which namespaced types are returned, you add the
  ## `namespacedType` query parameter to the request. You must either use
  ## `*/*`, to return all attachments, or the namespace must be one of
  ## the ones returned from the  `namespaces` endpoint.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  let valid = call_579073.validator(path, query, header, formData, body)
  let scheme = call_579073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579073.url(scheme.get, call_579073.host, call_579073.base,
                         call_579073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579073, url, valid)

proc call*(call_579074: Call_ProximitybeaconBeaconsAttachmentsList_579056;
          beaconName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          namespacedType: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsAttachmentsList
  ## Returns the attachments for the specified beacon that match the specified
  ## namespaced-type pattern.
  ## 
  ## To control which namespaced types are returned, you add the
  ## `namespacedType` query parameter to the request. You must either use
  ## `*/*`, to return all attachments, or the namespace must be one of
  ## the ones returned from the  `namespaces` endpoint.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
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
  ##   callback: string
  ##           : JSONP
  ##   namespacedType: string
  ##                 : Specifies the namespace and type of attachment to include in response in
  ## <var>namespace/type</var> format. Accepts `*/*` to specify
  ## "all types in all namespaces".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   beaconName: string (required)
  ##             : Beacon whose attachments should be fetched. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   projectId: string
  ##            : The project id to list beacon attachments under. This field can be
  ## used when "*" is specified to mean all attachment namespaces. Projects
  ## may have multiple attachments with multiple namespaces. If "*" is
  ## specified and the projectId string is empty, then the project
  ## making the request is used.
  ## Optional.
  var path_579075 = newJObject()
  var query_579076 = newJObject()
  add(query_579076, "key", newJString(key))
  add(query_579076, "prettyPrint", newJBool(prettyPrint))
  add(query_579076, "oauth_token", newJString(oauthToken))
  add(query_579076, "$.xgafv", newJString(Xgafv))
  add(query_579076, "alt", newJString(alt))
  add(query_579076, "uploadType", newJString(uploadType))
  add(query_579076, "quotaUser", newJString(quotaUser))
  add(query_579076, "callback", newJString(callback))
  add(query_579076, "namespacedType", newJString(namespacedType))
  add(query_579076, "fields", newJString(fields))
  add(query_579076, "access_token", newJString(accessToken))
  add(query_579076, "upload_protocol", newJString(uploadProtocol))
  add(path_579075, "beaconName", newJString(beaconName))
  add(query_579076, "projectId", newJString(projectId))
  result = call_579074.call(path_579075, query_579076, nil, nil, nil)

var proximitybeaconBeaconsAttachmentsList* = Call_ProximitybeaconBeaconsAttachmentsList_579056(
    name: "proximitybeaconBeaconsAttachmentsList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/attachments",
    validator: validate_ProximitybeaconBeaconsAttachmentsList_579057, base: "/",
    url: url_ProximitybeaconBeaconsAttachmentsList_579058, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsAttachmentsBatchDelete_579099 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsAttachmentsBatchDelete_579101(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: "/attachments:batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsAttachmentsBatchDelete_579100(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes multiple attachments on a given beacon. This operation is
  ## permanent and cannot be undone.
  ## 
  ## You can optionally specify `namespacedType` to choose which attachments
  ## should be deleted. If you do not specify `namespacedType`,  all your
  ## attachments on the given beacon will be deleted. You also may explicitly
  ## specify `*/*` to delete all.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : The beacon whose attachments should be deleted. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_579102 = path.getOrDefault("beaconName")
  valid_579102 = validateParameter(valid_579102, JString, required = true,
                                 default = nil)
  if valid_579102 != nil:
    section.add "beaconName", valid_579102
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
  ##   namespacedType: JString
  ##                 : Specifies the namespace and type of attachments to delete in
  ## `namespace/type` format. Accepts `*/*` to specify
  ## "all types in all namespaces".
  ## Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : The project id to delete beacon attachments under. This field can be
  ## used when "*" is specified to mean all attachment namespaces. Projects
  ## may have multiple attachments with multiple namespaces. If "*" is
  ## specified and the projectId string is empty, then the project
  ## making the request is used.
  ## Optional.
  section = newJObject()
  var valid_579103 = query.getOrDefault("key")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "key", valid_579103
  var valid_579104 = query.getOrDefault("prettyPrint")
  valid_579104 = validateParameter(valid_579104, JBool, required = false,
                                 default = newJBool(true))
  if valid_579104 != nil:
    section.add "prettyPrint", valid_579104
  var valid_579105 = query.getOrDefault("oauth_token")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "oauth_token", valid_579105
  var valid_579106 = query.getOrDefault("$.xgafv")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = newJString("1"))
  if valid_579106 != nil:
    section.add "$.xgafv", valid_579106
  var valid_579107 = query.getOrDefault("alt")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = newJString("json"))
  if valid_579107 != nil:
    section.add "alt", valid_579107
  var valid_579108 = query.getOrDefault("uploadType")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "uploadType", valid_579108
  var valid_579109 = query.getOrDefault("quotaUser")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "quotaUser", valid_579109
  var valid_579110 = query.getOrDefault("callback")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "callback", valid_579110
  var valid_579111 = query.getOrDefault("namespacedType")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "namespacedType", valid_579111
  var valid_579112 = query.getOrDefault("fields")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "fields", valid_579112
  var valid_579113 = query.getOrDefault("access_token")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "access_token", valid_579113
  var valid_579114 = query.getOrDefault("upload_protocol")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "upload_protocol", valid_579114
  var valid_579115 = query.getOrDefault("projectId")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "projectId", valid_579115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579116: Call_ProximitybeaconBeaconsAttachmentsBatchDelete_579099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes multiple attachments on a given beacon. This operation is
  ## permanent and cannot be undone.
  ## 
  ## You can optionally specify `namespacedType` to choose which attachments
  ## should be deleted. If you do not specify `namespacedType`,  all your
  ## attachments on the given beacon will be deleted. You also may explicitly
  ## specify `*/*` to delete all.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_579116.validator(path, query, header, formData, body)
  let scheme = call_579116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579116.url(scheme.get, call_579116.host, call_579116.base,
                         call_579116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579116, url, valid)

proc call*(call_579117: Call_ProximitybeaconBeaconsAttachmentsBatchDelete_579099;
          beaconName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          namespacedType: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsAttachmentsBatchDelete
  ## Deletes multiple attachments on a given beacon. This operation is
  ## permanent and cannot be undone.
  ## 
  ## You can optionally specify `namespacedType` to choose which attachments
  ## should be deleted. If you do not specify `namespacedType`,  all your
  ## attachments on the given beacon will be deleted. You also may explicitly
  ## specify `*/*` to delete all.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
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
  ##   callback: string
  ##           : JSONP
  ##   namespacedType: string
  ##                 : Specifies the namespace and type of attachments to delete in
  ## `namespace/type` format. Accepts `*/*` to specify
  ## "all types in all namespaces".
  ## Optional.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   beaconName: string (required)
  ##             : The beacon whose attachments should be deleted. A beacon name has the
  ## format "beacons/N!beaconId" where the beaconId is the base16 ID broadcast
  ## by the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   projectId: string
  ##            : The project id to delete beacon attachments under. This field can be
  ## used when "*" is specified to mean all attachment namespaces. Projects
  ## may have multiple attachments with multiple namespaces. If "*" is
  ## specified and the projectId string is empty, then the project
  ## making the request is used.
  ## Optional.
  var path_579118 = newJObject()
  var query_579119 = newJObject()
  add(query_579119, "key", newJString(key))
  add(query_579119, "prettyPrint", newJBool(prettyPrint))
  add(query_579119, "oauth_token", newJString(oauthToken))
  add(query_579119, "$.xgafv", newJString(Xgafv))
  add(query_579119, "alt", newJString(alt))
  add(query_579119, "uploadType", newJString(uploadType))
  add(query_579119, "quotaUser", newJString(quotaUser))
  add(query_579119, "callback", newJString(callback))
  add(query_579119, "namespacedType", newJString(namespacedType))
  add(query_579119, "fields", newJString(fields))
  add(query_579119, "access_token", newJString(accessToken))
  add(query_579119, "upload_protocol", newJString(uploadProtocol))
  add(path_579118, "beaconName", newJString(beaconName))
  add(query_579119, "projectId", newJString(projectId))
  result = call_579117.call(path_579118, query_579119, nil, nil, nil)

var proximitybeaconBeaconsAttachmentsBatchDelete* = Call_ProximitybeaconBeaconsAttachmentsBatchDelete_579099(
    name: "proximitybeaconBeaconsAttachmentsBatchDelete",
    meth: HttpMethod.HttpPost, host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/attachments:batchDelete",
    validator: validate_ProximitybeaconBeaconsAttachmentsBatchDelete_579100,
    base: "/", url: url_ProximitybeaconBeaconsAttachmentsBatchDelete_579101,
    schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDiagnosticsList_579120 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsDiagnosticsList_579122(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: "/diagnostics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDiagnosticsList_579121(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the diagnostics for a single beacon. You can also list diagnostics for
  ## all the beacons owned by your Google Developers Console project by using
  ## the beacon name `beacons/-`.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that the diagnostics are for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_579123 = path.getOrDefault("beaconName")
  valid_579123 = validateParameter(valid_579123, JString, required = true,
                                 default = nil)
  if valid_579123 != nil:
    section.add "beaconName", valid_579123
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
  ##   pageSize: JInt
  ##           : Specifies the maximum number of results to return. Defaults to
  ## 10. Maximum 1000. Optional.
  ##   alertFilter: JString
  ##              : Requests only beacons that have the given alert. For example, to find
  ## beacons that have low batteries use `alert_filter=LOW_BATTERY`.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Requests results that occur after the `page_token`, obtained from the
  ## response to a previous request. Optional.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : Requests only diagnostic records for the given project id. If not set,
  ## then the project making the request will be used for looking up
  ## diagnostic records. Optional.
  section = newJObject()
  var valid_579124 = query.getOrDefault("key")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "key", valid_579124
  var valid_579125 = query.getOrDefault("prettyPrint")
  valid_579125 = validateParameter(valid_579125, JBool, required = false,
                                 default = newJBool(true))
  if valid_579125 != nil:
    section.add "prettyPrint", valid_579125
  var valid_579126 = query.getOrDefault("oauth_token")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "oauth_token", valid_579126
  var valid_579127 = query.getOrDefault("$.xgafv")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = newJString("1"))
  if valid_579127 != nil:
    section.add "$.xgafv", valid_579127
  var valid_579128 = query.getOrDefault("pageSize")
  valid_579128 = validateParameter(valid_579128, JInt, required = false, default = nil)
  if valid_579128 != nil:
    section.add "pageSize", valid_579128
  var valid_579129 = query.getOrDefault("alertFilter")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = newJString("ALERT_UNSPECIFIED"))
  if valid_579129 != nil:
    section.add "alertFilter", valid_579129
  var valid_579130 = query.getOrDefault("alt")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = newJString("json"))
  if valid_579130 != nil:
    section.add "alt", valid_579130
  var valid_579131 = query.getOrDefault("uploadType")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "uploadType", valid_579131
  var valid_579132 = query.getOrDefault("quotaUser")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "quotaUser", valid_579132
  var valid_579133 = query.getOrDefault("pageToken")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "pageToken", valid_579133
  var valid_579134 = query.getOrDefault("callback")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "callback", valid_579134
  var valid_579135 = query.getOrDefault("fields")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "fields", valid_579135
  var valid_579136 = query.getOrDefault("access_token")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "access_token", valid_579136
  var valid_579137 = query.getOrDefault("upload_protocol")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "upload_protocol", valid_579137
  var valid_579138 = query.getOrDefault("projectId")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "projectId", valid_579138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579139: Call_ProximitybeaconBeaconsDiagnosticsList_579120;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the diagnostics for a single beacon. You can also list diagnostics for
  ## all the beacons owned by your Google Developers Console project by using
  ## the beacon name `beacons/-`.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ## 
  let valid = call_579139.validator(path, query, header, formData, body)
  let scheme = call_579139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579139.url(scheme.get, call_579139.host, call_579139.base,
                         call_579139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579139, url, valid)

proc call*(call_579140: Call_ProximitybeaconBeaconsDiagnosticsList_579120;
          beaconName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alertFilter: string = "ALERT_UNSPECIFIED"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsDiagnosticsList
  ## List the diagnostics for a single beacon. You can also list diagnostics for
  ## all the beacons owned by your Google Developers Console project by using
  ## the beacon name `beacons/-`.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **viewer**, **Is owner** or **Can edit** permissions in
  ## the Google Developers Console project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the maximum number of results to return. Defaults to
  ## 10. Maximum 1000. Optional.
  ##   alertFilter: string
  ##              : Requests only beacons that have the given alert. For example, to find
  ## beacons that have low batteries use `alert_filter=LOW_BATTERY`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Requests results that occur after the `page_token`, obtained from the
  ## response to a previous request. Optional.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   beaconName: string (required)
  ##             : Beacon that the diagnostics are for.
  ##   projectId: string
  ##            : Requests only diagnostic records for the given project id. If not set,
  ## then the project making the request will be used for looking up
  ## diagnostic records. Optional.
  var path_579141 = newJObject()
  var query_579142 = newJObject()
  add(query_579142, "key", newJString(key))
  add(query_579142, "prettyPrint", newJBool(prettyPrint))
  add(query_579142, "oauth_token", newJString(oauthToken))
  add(query_579142, "$.xgafv", newJString(Xgafv))
  add(query_579142, "pageSize", newJInt(pageSize))
  add(query_579142, "alertFilter", newJString(alertFilter))
  add(query_579142, "alt", newJString(alt))
  add(query_579142, "uploadType", newJString(uploadType))
  add(query_579142, "quotaUser", newJString(quotaUser))
  add(query_579142, "pageToken", newJString(pageToken))
  add(query_579142, "callback", newJString(callback))
  add(query_579142, "fields", newJString(fields))
  add(query_579142, "access_token", newJString(accessToken))
  add(query_579142, "upload_protocol", newJString(uploadProtocol))
  add(path_579141, "beaconName", newJString(beaconName))
  add(query_579142, "projectId", newJString(projectId))
  result = call_579140.call(path_579141, query_579142, nil, nil, nil)

var proximitybeaconBeaconsDiagnosticsList* = Call_ProximitybeaconBeaconsDiagnosticsList_579120(
    name: "proximitybeaconBeaconsDiagnosticsList", meth: HttpMethod.HttpGet,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}/diagnostics",
    validator: validate_ProximitybeaconBeaconsDiagnosticsList_579121, base: "/",
    url: url_ProximitybeaconBeaconsDiagnosticsList_579122, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsActivate_579143 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsActivate_579145(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: ":activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsActivate_579144(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Activates a beacon. A beacon that is active will return information
  ## and attachment data when queried via `beaconinfo.getforobserved`.
  ## Calling this method on an already active beacon will do nothing (but
  ## will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that should be activated. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_579146 = path.getOrDefault("beaconName")
  valid_579146 = validateParameter(valid_579146, JString, required = true,
                                 default = nil)
  if valid_579146 != nil:
    section.add "beaconName", valid_579146
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
  ##   projectId: JString
  ##            : The project id of the beacon to activate. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  section = newJObject()
  var valid_579147 = query.getOrDefault("key")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "key", valid_579147
  var valid_579148 = query.getOrDefault("prettyPrint")
  valid_579148 = validateParameter(valid_579148, JBool, required = false,
                                 default = newJBool(true))
  if valid_579148 != nil:
    section.add "prettyPrint", valid_579148
  var valid_579149 = query.getOrDefault("oauth_token")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "oauth_token", valid_579149
  var valid_579150 = query.getOrDefault("$.xgafv")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = newJString("1"))
  if valid_579150 != nil:
    section.add "$.xgafv", valid_579150
  var valid_579151 = query.getOrDefault("alt")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = newJString("json"))
  if valid_579151 != nil:
    section.add "alt", valid_579151
  var valid_579152 = query.getOrDefault("uploadType")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "uploadType", valid_579152
  var valid_579153 = query.getOrDefault("quotaUser")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "quotaUser", valid_579153
  var valid_579154 = query.getOrDefault("callback")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "callback", valid_579154
  var valid_579155 = query.getOrDefault("fields")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "fields", valid_579155
  var valid_579156 = query.getOrDefault("access_token")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "access_token", valid_579156
  var valid_579157 = query.getOrDefault("upload_protocol")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "upload_protocol", valid_579157
  var valid_579158 = query.getOrDefault("projectId")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "projectId", valid_579158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579159: Call_ProximitybeaconBeaconsActivate_579143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates a beacon. A beacon that is active will return information
  ## and attachment data when queried via `beaconinfo.getforobserved`.
  ## Calling this method on an already active beacon will do nothing (but
  ## will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_579159.validator(path, query, header, formData, body)
  let scheme = call_579159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579159.url(scheme.get, call_579159.host, call_579159.base,
                         call_579159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579159, url, valid)

proc call*(call_579160: Call_ProximitybeaconBeaconsActivate_579143;
          beaconName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsActivate
  ## Activates a beacon. A beacon that is active will return information
  ## and attachment data when queried via `beaconinfo.getforobserved`.
  ## Calling this method on an already active beacon will do nothing (but
  ## will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   beaconName: string (required)
  ##             : Beacon that should be activated. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   projectId: string
  ##            : The project id of the beacon to activate. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  var path_579161 = newJObject()
  var query_579162 = newJObject()
  add(query_579162, "key", newJString(key))
  add(query_579162, "prettyPrint", newJBool(prettyPrint))
  add(query_579162, "oauth_token", newJString(oauthToken))
  add(query_579162, "$.xgafv", newJString(Xgafv))
  add(query_579162, "alt", newJString(alt))
  add(query_579162, "uploadType", newJString(uploadType))
  add(query_579162, "quotaUser", newJString(quotaUser))
  add(query_579162, "callback", newJString(callback))
  add(query_579162, "fields", newJString(fields))
  add(query_579162, "access_token", newJString(accessToken))
  add(query_579162, "upload_protocol", newJString(uploadProtocol))
  add(path_579161, "beaconName", newJString(beaconName))
  add(query_579162, "projectId", newJString(projectId))
  result = call_579160.call(path_579161, query_579162, nil, nil, nil)

var proximitybeaconBeaconsActivate* = Call_ProximitybeaconBeaconsActivate_579143(
    name: "proximitybeaconBeaconsActivate", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}:activate",
    validator: validate_ProximitybeaconBeaconsActivate_579144, base: "/",
    url: url_ProximitybeaconBeaconsActivate_579145, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDeactivate_579163 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsDeactivate_579165(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: ":deactivate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDeactivate_579164(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deactivates a beacon. Once deactivated, the API will not return
  ## information nor attachment data for the beacon when queried via
  ## `beaconinfo.getforobserved`. Calling this method on an already inactive
  ## beacon will do nothing (but will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that should be deactivated. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_579166 = path.getOrDefault("beaconName")
  valid_579166 = validateParameter(valid_579166, JString, required = true,
                                 default = nil)
  if valid_579166 != nil:
    section.add "beaconName", valid_579166
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
  ##   projectId: JString
  ##            : The project id of the beacon to deactivate. If the project id is not
  ## specified then the project making the request is used. The project id must
  ## match the project that owns the beacon.
  ## Optional.
  section = newJObject()
  var valid_579167 = query.getOrDefault("key")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "key", valid_579167
  var valid_579168 = query.getOrDefault("prettyPrint")
  valid_579168 = validateParameter(valid_579168, JBool, required = false,
                                 default = newJBool(true))
  if valid_579168 != nil:
    section.add "prettyPrint", valid_579168
  var valid_579169 = query.getOrDefault("oauth_token")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "oauth_token", valid_579169
  var valid_579170 = query.getOrDefault("$.xgafv")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = newJString("1"))
  if valid_579170 != nil:
    section.add "$.xgafv", valid_579170
  var valid_579171 = query.getOrDefault("alt")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = newJString("json"))
  if valid_579171 != nil:
    section.add "alt", valid_579171
  var valid_579172 = query.getOrDefault("uploadType")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "uploadType", valid_579172
  var valid_579173 = query.getOrDefault("quotaUser")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "quotaUser", valid_579173
  var valid_579174 = query.getOrDefault("callback")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "callback", valid_579174
  var valid_579175 = query.getOrDefault("fields")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "fields", valid_579175
  var valid_579176 = query.getOrDefault("access_token")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "access_token", valid_579176
  var valid_579177 = query.getOrDefault("upload_protocol")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "upload_protocol", valid_579177
  var valid_579178 = query.getOrDefault("projectId")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "projectId", valid_579178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579179: Call_ProximitybeaconBeaconsDeactivate_579163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deactivates a beacon. Once deactivated, the API will not return
  ## information nor attachment data for the beacon when queried via
  ## `beaconinfo.getforobserved`. Calling this method on an already inactive
  ## beacon will do nothing (but will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_579179.validator(path, query, header, formData, body)
  let scheme = call_579179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579179.url(scheme.get, call_579179.host, call_579179.base,
                         call_579179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579179, url, valid)

proc call*(call_579180: Call_ProximitybeaconBeaconsDeactivate_579163;
          beaconName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsDeactivate
  ## Deactivates a beacon. Once deactivated, the API will not return
  ## information nor attachment data for the beacon when queried via
  ## `beaconinfo.getforobserved`. Calling this method on an already inactive
  ## beacon will do nothing (but will return a successful response code).
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   beaconName: string (required)
  ##             : Beacon that should be deactivated. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID or the beacon's "stable" UID.
  ## Required.
  ##   projectId: string
  ##            : The project id of the beacon to deactivate. If the project id is not
  ## specified then the project making the request is used. The project id must
  ## match the project that owns the beacon.
  ## Optional.
  var path_579181 = newJObject()
  var query_579182 = newJObject()
  add(query_579182, "key", newJString(key))
  add(query_579182, "prettyPrint", newJBool(prettyPrint))
  add(query_579182, "oauth_token", newJString(oauthToken))
  add(query_579182, "$.xgafv", newJString(Xgafv))
  add(query_579182, "alt", newJString(alt))
  add(query_579182, "uploadType", newJString(uploadType))
  add(query_579182, "quotaUser", newJString(quotaUser))
  add(query_579182, "callback", newJString(callback))
  add(query_579182, "fields", newJString(fields))
  add(query_579182, "access_token", newJString(accessToken))
  add(query_579182, "upload_protocol", newJString(uploadProtocol))
  add(path_579181, "beaconName", newJString(beaconName))
  add(query_579182, "projectId", newJString(projectId))
  result = call_579180.call(path_579181, query_579182, nil, nil, nil)

var proximitybeaconBeaconsDeactivate* = Call_ProximitybeaconBeaconsDeactivate_579163(
    name: "proximitybeaconBeaconsDeactivate", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}:deactivate",
    validator: validate_ProximitybeaconBeaconsDeactivate_579164, base: "/",
    url: url_ProximitybeaconBeaconsDeactivate_579165, schemes: {Scheme.Https})
type
  Call_ProximitybeaconBeaconsDecommission_579183 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconBeaconsDecommission_579185(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "beaconName" in path, "`beaconName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "beaconName"),
               (kind: ConstantSegment, value: ":decommission")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconBeaconsDecommission_579184(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Decommissions the specified beacon in the service. This beacon will no
  ## longer be returned from `beaconinfo.getforobserved`. This operation is
  ## permanent -- you will not be able to re-register a beacon with this ID
  ## again.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   beaconName: JString (required)
  ##             : Beacon that should be decommissioned. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID of the beacon's "stable" UID.
  ## Required.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `beaconName` field"
  var valid_579186 = path.getOrDefault("beaconName")
  valid_579186 = validateParameter(valid_579186, JString, required = true,
                                 default = nil)
  if valid_579186 != nil:
    section.add "beaconName", valid_579186
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
  ##   projectId: JString
  ##            : The project id of the beacon to decommission. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  section = newJObject()
  var valid_579187 = query.getOrDefault("key")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "key", valid_579187
  var valid_579188 = query.getOrDefault("prettyPrint")
  valid_579188 = validateParameter(valid_579188, JBool, required = false,
                                 default = newJBool(true))
  if valid_579188 != nil:
    section.add "prettyPrint", valid_579188
  var valid_579189 = query.getOrDefault("oauth_token")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "oauth_token", valid_579189
  var valid_579190 = query.getOrDefault("$.xgafv")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = newJString("1"))
  if valid_579190 != nil:
    section.add "$.xgafv", valid_579190
  var valid_579191 = query.getOrDefault("alt")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = newJString("json"))
  if valid_579191 != nil:
    section.add "alt", valid_579191
  var valid_579192 = query.getOrDefault("uploadType")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "uploadType", valid_579192
  var valid_579193 = query.getOrDefault("quotaUser")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "quotaUser", valid_579193
  var valid_579194 = query.getOrDefault("callback")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "callback", valid_579194
  var valid_579195 = query.getOrDefault("fields")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "fields", valid_579195
  var valid_579196 = query.getOrDefault("access_token")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "access_token", valid_579196
  var valid_579197 = query.getOrDefault("upload_protocol")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "upload_protocol", valid_579197
  var valid_579198 = query.getOrDefault("projectId")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "projectId", valid_579198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579199: Call_ProximitybeaconBeaconsDecommission_579183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decommissions the specified beacon in the service. This beacon will no
  ## longer be returned from `beaconinfo.getforobserved`. This operation is
  ## permanent -- you will not be able to re-register a beacon with this ID
  ## again.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
  ## 
  let valid = call_579199.validator(path, query, header, formData, body)
  let scheme = call_579199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579199.url(scheme.get, call_579199.host, call_579199.base,
                         call_579199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579199, url, valid)

proc call*(call_579200: Call_ProximitybeaconBeaconsDecommission_579183;
          beaconName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          projectId: string = ""): Recallable =
  ## proximitybeaconBeaconsDecommission
  ## Decommissions the specified beacon in the service. This beacon will no
  ## longer be returned from `beaconinfo.getforobserved`. This operation is
  ## permanent -- you will not be able to re-register a beacon with this ID
  ## again.
  ## 
  ## Authenticate using an [OAuth access
  ## token](https://developers.google.com/identity/protocols/OAuth2) from a
  ## signed-in user with **Is owner** or **Can edit** permissions in the Google
  ## Developers Console project.
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   beaconName: string (required)
  ##             : Beacon that should be decommissioned. A beacon name has the format
  ## "beacons/N!beaconId" where the beaconId is the base16 ID broadcast by
  ## the beacon and N is a code for the beacon's type. Possible values are
  ## `3` for Eddystone-UID, `4` for Eddystone-EID, `1` for iBeacon, or `5`
  ## for AltBeacon. For Eddystone-EID beacons, you may use either the
  ## current EID of the beacon's "stable" UID.
  ## Required.
  ##   projectId: string
  ##            : The project id of the beacon to decommission. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  var path_579201 = newJObject()
  var query_579202 = newJObject()
  add(query_579202, "key", newJString(key))
  add(query_579202, "prettyPrint", newJBool(prettyPrint))
  add(query_579202, "oauth_token", newJString(oauthToken))
  add(query_579202, "$.xgafv", newJString(Xgafv))
  add(query_579202, "alt", newJString(alt))
  add(query_579202, "uploadType", newJString(uploadType))
  add(query_579202, "quotaUser", newJString(quotaUser))
  add(query_579202, "callback", newJString(callback))
  add(query_579202, "fields", newJString(fields))
  add(query_579202, "access_token", newJString(accessToken))
  add(query_579202, "upload_protocol", newJString(uploadProtocol))
  add(path_579201, "beaconName", newJString(beaconName))
  add(query_579202, "projectId", newJString(projectId))
  result = call_579200.call(path_579201, query_579202, nil, nil, nil)

var proximitybeaconBeaconsDecommission* = Call_ProximitybeaconBeaconsDecommission_579183(
    name: "proximitybeaconBeaconsDecommission", meth: HttpMethod.HttpPost,
    host: "proximitybeacon.googleapis.com",
    route: "/v1beta1/{beaconName}:decommission",
    validator: validate_ProximitybeaconBeaconsDecommission_579184, base: "/",
    url: url_ProximitybeaconBeaconsDecommission_579185, schemes: {Scheme.Https})
type
  Call_ProximitybeaconNamespacesUpdate_579203 = ref object of OpenApiRestCall_578339
proc url_ProximitybeaconNamespacesUpdate_579205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximitybeaconNamespacesUpdate_579204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the information about the specified namespace. Only the namespace
  ## visibility can be updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : Resource name of this namespace. Namespaces names have the format:
  ## <code>namespaces/<var>namespace</var></code>.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_579206 = path.getOrDefault("namespaceName")
  valid_579206 = validateParameter(valid_579206, JString, required = true,
                                 default = nil)
  if valid_579206 != nil:
    section.add "namespaceName", valid_579206
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
  ##   projectId: JString
  ##            : The project id of the namespace to update. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  section = newJObject()
  var valid_579207 = query.getOrDefault("key")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "key", valid_579207
  var valid_579208 = query.getOrDefault("prettyPrint")
  valid_579208 = validateParameter(valid_579208, JBool, required = false,
                                 default = newJBool(true))
  if valid_579208 != nil:
    section.add "prettyPrint", valid_579208
  var valid_579209 = query.getOrDefault("oauth_token")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "oauth_token", valid_579209
  var valid_579210 = query.getOrDefault("$.xgafv")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = newJString("1"))
  if valid_579210 != nil:
    section.add "$.xgafv", valid_579210
  var valid_579211 = query.getOrDefault("alt")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = newJString("json"))
  if valid_579211 != nil:
    section.add "alt", valid_579211
  var valid_579212 = query.getOrDefault("uploadType")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "uploadType", valid_579212
  var valid_579213 = query.getOrDefault("quotaUser")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "quotaUser", valid_579213
  var valid_579214 = query.getOrDefault("callback")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "callback", valid_579214
  var valid_579215 = query.getOrDefault("fields")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "fields", valid_579215
  var valid_579216 = query.getOrDefault("access_token")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "access_token", valid_579216
  var valid_579217 = query.getOrDefault("upload_protocol")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "upload_protocol", valid_579217
  var valid_579218 = query.getOrDefault("projectId")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "projectId", valid_579218
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

proc call*(call_579220: Call_ProximitybeaconNamespacesUpdate_579203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the information about the specified namespace. Only the namespace
  ## visibility can be updated.
  ## 
  let valid = call_579220.validator(path, query, header, formData, body)
  let scheme = call_579220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579220.url(scheme.get, call_579220.host, call_579220.base,
                         call_579220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579220, url, valid)

proc call*(call_579221: Call_ProximitybeaconNamespacesUpdate_579203;
          namespaceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## proximitybeaconNamespacesUpdate
  ## Updates the information about the specified namespace. Only the namespace
  ## visibility can be updated.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   namespaceName: string (required)
  ##                : Resource name of this namespace. Namespaces names have the format:
  ## <code>namespaces/<var>namespace</var></code>.
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
  ##   projectId: string
  ##            : The project id of the namespace to update. If the project id is not
  ## specified then the project making the request is used. The project id
  ## must match the project that owns the beacon.
  ## Optional.
  var path_579222 = newJObject()
  var query_579223 = newJObject()
  var body_579224 = newJObject()
  add(query_579223, "key", newJString(key))
  add(query_579223, "prettyPrint", newJBool(prettyPrint))
  add(query_579223, "oauth_token", newJString(oauthToken))
  add(query_579223, "$.xgafv", newJString(Xgafv))
  add(path_579222, "namespaceName", newJString(namespaceName))
  add(query_579223, "alt", newJString(alt))
  add(query_579223, "uploadType", newJString(uploadType))
  add(query_579223, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579224 = body
  add(query_579223, "callback", newJString(callback))
  add(query_579223, "fields", newJString(fields))
  add(query_579223, "access_token", newJString(accessToken))
  add(query_579223, "upload_protocol", newJString(uploadProtocol))
  add(query_579223, "projectId", newJString(projectId))
  result = call_579221.call(path_579222, query_579223, nil, nil, body_579224)

var proximitybeaconNamespacesUpdate* = Call_ProximitybeaconNamespacesUpdate_579203(
    name: "proximitybeaconNamespacesUpdate", meth: HttpMethod.HttpPut,
    host: "proximitybeacon.googleapis.com", route: "/v1beta1/{namespaceName}",
    validator: validate_ProximitybeaconNamespacesUpdate_579204, base: "/",
    url: url_ProximitybeaconNamespacesUpdate_579205, schemes: {Scheme.Https})
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
