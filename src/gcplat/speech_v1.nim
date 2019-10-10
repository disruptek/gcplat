
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Speech-to-Text
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Converts audio to text by applying powerful neural network models.
## 
## https://cloud.google.com/speech-to-text/docs/quickstart-protocol
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
  gcpServiceName = "speech"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SpeechOperationsList_588710 = ref object of OpenApiRestCall_588441
proc url_SpeechOperationsList_588712(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpeechOperationsList_588711(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
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
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##   name: JString
  ##       : The name of the operation's parent resource.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
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
  var valid_588826 = query.getOrDefault("pageToken")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "pageToken", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("oauth_token")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "oauth_token", valid_588842
  var valid_588843 = query.getOrDefault("callback")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "callback", valid_588843
  var valid_588844 = query.getOrDefault("access_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "access_token", valid_588844
  var valid_588845 = query.getOrDefault("uploadType")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "uploadType", valid_588845
  var valid_588846 = query.getOrDefault("key")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "key", valid_588846
  var valid_588847 = query.getOrDefault("name")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "name", valid_588847
  var valid_588848 = query.getOrDefault("$.xgafv")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = newJString("1"))
  if valid_588848 != nil:
    section.add "$.xgafv", valid_588848
  var valid_588849 = query.getOrDefault("pageSize")
  valid_588849 = validateParameter(valid_588849, JInt, required = false, default = nil)
  if valid_588849 != nil:
    section.add "pageSize", valid_588849
  var valid_588850 = query.getOrDefault("prettyPrint")
  valid_588850 = validateParameter(valid_588850, JBool, required = false,
                                 default = newJBool(true))
  if valid_588850 != nil:
    section.add "prettyPrint", valid_588850
  var valid_588851 = query.getOrDefault("filter")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "filter", valid_588851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588874: Call_SpeechOperationsList_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_588874.validator(path, query, header, formData, body)
  let scheme = call_588874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588874.url(scheme.get, call_588874.host, call_588874.base,
                         call_588874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588874, url, valid)

proc call*(call_588945: Call_SpeechOperationsList_588710;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## speechOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
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
  ##   name: string
  ##       : The name of the operation's parent resource.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var query_588946 = newJObject()
  add(query_588946, "upload_protocol", newJString(uploadProtocol))
  add(query_588946, "fields", newJString(fields))
  add(query_588946, "pageToken", newJString(pageToken))
  add(query_588946, "quotaUser", newJString(quotaUser))
  add(query_588946, "alt", newJString(alt))
  add(query_588946, "oauth_token", newJString(oauthToken))
  add(query_588946, "callback", newJString(callback))
  add(query_588946, "access_token", newJString(accessToken))
  add(query_588946, "uploadType", newJString(uploadType))
  add(query_588946, "key", newJString(key))
  add(query_588946, "name", newJString(name))
  add(query_588946, "$.xgafv", newJString(Xgafv))
  add(query_588946, "pageSize", newJInt(pageSize))
  add(query_588946, "prettyPrint", newJBool(prettyPrint))
  add(query_588946, "filter", newJString(filter))
  result = call_588945.call(nil, query_588946, nil, nil, nil)

var speechOperationsList* = Call_SpeechOperationsList_588710(
    name: "speechOperationsList", meth: HttpMethod.HttpGet,
    host: "speech.googleapis.com", route: "/v1/operations",
    validator: validate_SpeechOperationsList_588711, base: "/",
    url: url_SpeechOperationsList_588712, schemes: {Scheme.Https})
type
  Call_SpeechOperationsGet_588986 = ref object of OpenApiRestCall_588441
proc url_SpeechOperationsGet_588988(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/operations/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpeechOperationsGet_588987(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589003 = path.getOrDefault("name")
  valid_589003 = validateParameter(valid_589003, JString, required = true,
                                 default = nil)
  if valid_589003 != nil:
    section.add "name", valid_589003
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
  var valid_589004 = query.getOrDefault("upload_protocol")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "upload_protocol", valid_589004
  var valid_589005 = query.getOrDefault("fields")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "fields", valid_589005
  var valid_589006 = query.getOrDefault("quotaUser")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "quotaUser", valid_589006
  var valid_589007 = query.getOrDefault("alt")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = newJString("json"))
  if valid_589007 != nil:
    section.add "alt", valid_589007
  var valid_589008 = query.getOrDefault("oauth_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "oauth_token", valid_589008
  var valid_589009 = query.getOrDefault("callback")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "callback", valid_589009
  var valid_589010 = query.getOrDefault("access_token")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "access_token", valid_589010
  var valid_589011 = query.getOrDefault("uploadType")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "uploadType", valid_589011
  var valid_589012 = query.getOrDefault("key")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "key", valid_589012
  var valid_589013 = query.getOrDefault("$.xgafv")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = newJString("1"))
  if valid_589013 != nil:
    section.add "$.xgafv", valid_589013
  var valid_589014 = query.getOrDefault("prettyPrint")
  valid_589014 = validateParameter(valid_589014, JBool, required = false,
                                 default = newJBool(true))
  if valid_589014 != nil:
    section.add "prettyPrint", valid_589014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589015: Call_SpeechOperationsGet_588986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_589015.validator(path, query, header, formData, body)
  let scheme = call_589015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589015.url(scheme.get, call_589015.host, call_589015.base,
                         call_589015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589015, url, valid)

proc call*(call_589016: Call_SpeechOperationsGet_588986; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## speechOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589017 = newJObject()
  var query_589018 = newJObject()
  add(query_589018, "upload_protocol", newJString(uploadProtocol))
  add(query_589018, "fields", newJString(fields))
  add(query_589018, "quotaUser", newJString(quotaUser))
  add(path_589017, "name", newJString(name))
  add(query_589018, "alt", newJString(alt))
  add(query_589018, "oauth_token", newJString(oauthToken))
  add(query_589018, "callback", newJString(callback))
  add(query_589018, "access_token", newJString(accessToken))
  add(query_589018, "uploadType", newJString(uploadType))
  add(query_589018, "key", newJString(key))
  add(query_589018, "$.xgafv", newJString(Xgafv))
  add(query_589018, "prettyPrint", newJBool(prettyPrint))
  result = call_589016.call(path_589017, query_589018, nil, nil, nil)

var speechOperationsGet* = Call_SpeechOperationsGet_588986(
    name: "speechOperationsGet", meth: HttpMethod.HttpGet,
    host: "speech.googleapis.com", route: "/v1/operations/{name}",
    validator: validate_SpeechOperationsGet_588987, base: "/",
    url: url_SpeechOperationsGet_588988, schemes: {Scheme.Https})
type
  Call_SpeechSpeechLongrunningrecognize_589019 = ref object of OpenApiRestCall_588441
proc url_SpeechSpeechLongrunningrecognize_589021(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpeechSpeechLongrunningrecognize_589020(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs asynchronous speech recognition: receive results via the
  ## google.longrunning.Operations interface. Returns either an
  ## `Operation.error` or an `Operation.response` which contains
  ## a `LongRunningRecognizeResponse` message.
  ## For more information on asynchronous speech recognition, see the
  ## [how-to](https://cloud.google.com/speech-to-text/docs/async-recognize).
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
  var valid_589022 = query.getOrDefault("upload_protocol")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "upload_protocol", valid_589022
  var valid_589023 = query.getOrDefault("fields")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "fields", valid_589023
  var valid_589024 = query.getOrDefault("quotaUser")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "quotaUser", valid_589024
  var valid_589025 = query.getOrDefault("alt")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = newJString("json"))
  if valid_589025 != nil:
    section.add "alt", valid_589025
  var valid_589026 = query.getOrDefault("oauth_token")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "oauth_token", valid_589026
  var valid_589027 = query.getOrDefault("callback")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "callback", valid_589027
  var valid_589028 = query.getOrDefault("access_token")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "access_token", valid_589028
  var valid_589029 = query.getOrDefault("uploadType")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "uploadType", valid_589029
  var valid_589030 = query.getOrDefault("key")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "key", valid_589030
  var valid_589031 = query.getOrDefault("$.xgafv")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = newJString("1"))
  if valid_589031 != nil:
    section.add "$.xgafv", valid_589031
  var valid_589032 = query.getOrDefault("prettyPrint")
  valid_589032 = validateParameter(valid_589032, JBool, required = false,
                                 default = newJBool(true))
  if valid_589032 != nil:
    section.add "prettyPrint", valid_589032
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

proc call*(call_589034: Call_SpeechSpeechLongrunningrecognize_589019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs asynchronous speech recognition: receive results via the
  ## google.longrunning.Operations interface. Returns either an
  ## `Operation.error` or an `Operation.response` which contains
  ## a `LongRunningRecognizeResponse` message.
  ## For more information on asynchronous speech recognition, see the
  ## [how-to](https://cloud.google.com/speech-to-text/docs/async-recognize).
  ## 
  let valid = call_589034.validator(path, query, header, formData, body)
  let scheme = call_589034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589034.url(scheme.get, call_589034.host, call_589034.base,
                         call_589034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589034, url, valid)

proc call*(call_589035: Call_SpeechSpeechLongrunningrecognize_589019;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## speechSpeechLongrunningrecognize
  ## Performs asynchronous speech recognition: receive results via the
  ## google.longrunning.Operations interface. Returns either an
  ## `Operation.error` or an `Operation.response` which contains
  ## a `LongRunningRecognizeResponse` message.
  ## For more information on asynchronous speech recognition, see the
  ## [how-to](https://cloud.google.com/speech-to-text/docs/async-recognize).
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
  var query_589036 = newJObject()
  var body_589037 = newJObject()
  add(query_589036, "upload_protocol", newJString(uploadProtocol))
  add(query_589036, "fields", newJString(fields))
  add(query_589036, "quotaUser", newJString(quotaUser))
  add(query_589036, "alt", newJString(alt))
  add(query_589036, "oauth_token", newJString(oauthToken))
  add(query_589036, "callback", newJString(callback))
  add(query_589036, "access_token", newJString(accessToken))
  add(query_589036, "uploadType", newJString(uploadType))
  add(query_589036, "key", newJString(key))
  add(query_589036, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589037 = body
  add(query_589036, "prettyPrint", newJBool(prettyPrint))
  result = call_589035.call(nil, query_589036, nil, nil, body_589037)

var speechSpeechLongrunningrecognize* = Call_SpeechSpeechLongrunningrecognize_589019(
    name: "speechSpeechLongrunningrecognize", meth: HttpMethod.HttpPost,
    host: "speech.googleapis.com", route: "/v1/speech:longrunningrecognize",
    validator: validate_SpeechSpeechLongrunningrecognize_589020, base: "/",
    url: url_SpeechSpeechLongrunningrecognize_589021, schemes: {Scheme.Https})
type
  Call_SpeechSpeechRecognize_589038 = ref object of OpenApiRestCall_588441
proc url_SpeechSpeechRecognize_589040(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpeechSpeechRecognize_589039(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs synchronous speech recognition: receive results after all audio
  ## has been sent and processed.
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
  var valid_589041 = query.getOrDefault("upload_protocol")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "upload_protocol", valid_589041
  var valid_589042 = query.getOrDefault("fields")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "fields", valid_589042
  var valid_589043 = query.getOrDefault("quotaUser")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "quotaUser", valid_589043
  var valid_589044 = query.getOrDefault("alt")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = newJString("json"))
  if valid_589044 != nil:
    section.add "alt", valid_589044
  var valid_589045 = query.getOrDefault("oauth_token")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "oauth_token", valid_589045
  var valid_589046 = query.getOrDefault("callback")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "callback", valid_589046
  var valid_589047 = query.getOrDefault("access_token")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "access_token", valid_589047
  var valid_589048 = query.getOrDefault("uploadType")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "uploadType", valid_589048
  var valid_589049 = query.getOrDefault("key")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "key", valid_589049
  var valid_589050 = query.getOrDefault("$.xgafv")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = newJString("1"))
  if valid_589050 != nil:
    section.add "$.xgafv", valid_589050
  var valid_589051 = query.getOrDefault("prettyPrint")
  valid_589051 = validateParameter(valid_589051, JBool, required = false,
                                 default = newJBool(true))
  if valid_589051 != nil:
    section.add "prettyPrint", valid_589051
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

proc call*(call_589053: Call_SpeechSpeechRecognize_589038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs synchronous speech recognition: receive results after all audio
  ## has been sent and processed.
  ## 
  let valid = call_589053.validator(path, query, header, formData, body)
  let scheme = call_589053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589053.url(scheme.get, call_589053.host, call_589053.base,
                         call_589053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589053, url, valid)

proc call*(call_589054: Call_SpeechSpeechRecognize_589038;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## speechSpeechRecognize
  ## Performs synchronous speech recognition: receive results after all audio
  ## has been sent and processed.
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
  var query_589055 = newJObject()
  var body_589056 = newJObject()
  add(query_589055, "upload_protocol", newJString(uploadProtocol))
  add(query_589055, "fields", newJString(fields))
  add(query_589055, "quotaUser", newJString(quotaUser))
  add(query_589055, "alt", newJString(alt))
  add(query_589055, "oauth_token", newJString(oauthToken))
  add(query_589055, "callback", newJString(callback))
  add(query_589055, "access_token", newJString(accessToken))
  add(query_589055, "uploadType", newJString(uploadType))
  add(query_589055, "key", newJString(key))
  add(query_589055, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589056 = body
  add(query_589055, "prettyPrint", newJBool(prettyPrint))
  result = call_589054.call(nil, query_589055, nil, nil, body_589056)

var speechSpeechRecognize* = Call_SpeechSpeechRecognize_589038(
    name: "speechSpeechRecognize", meth: HttpMethod.HttpPost,
    host: "speech.googleapis.com", route: "/v1/speech:recognize",
    validator: validate_SpeechSpeechRecognize_589039, base: "/",
    url: url_SpeechSpeechRecognize_589040, schemes: {Scheme.Https})
type
  Call_SpeechProjectsLocationsOperationsGet_589057 = ref object of OpenApiRestCall_588441
proc url_SpeechProjectsLocationsOperationsGet_589059(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpeechProjectsLocationsOperationsGet_589058(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589060 = path.getOrDefault("name")
  valid_589060 = validateParameter(valid_589060, JString, required = true,
                                 default = nil)
  if valid_589060 != nil:
    section.add "name", valid_589060
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
  var valid_589061 = query.getOrDefault("upload_protocol")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "upload_protocol", valid_589061
  var valid_589062 = query.getOrDefault("fields")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "fields", valid_589062
  var valid_589063 = query.getOrDefault("quotaUser")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "quotaUser", valid_589063
  var valid_589064 = query.getOrDefault("alt")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = newJString("json"))
  if valid_589064 != nil:
    section.add "alt", valid_589064
  var valid_589065 = query.getOrDefault("oauth_token")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "oauth_token", valid_589065
  var valid_589066 = query.getOrDefault("callback")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "callback", valid_589066
  var valid_589067 = query.getOrDefault("access_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "access_token", valid_589067
  var valid_589068 = query.getOrDefault("uploadType")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "uploadType", valid_589068
  var valid_589069 = query.getOrDefault("key")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "key", valid_589069
  var valid_589070 = query.getOrDefault("$.xgafv")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = newJString("1"))
  if valid_589070 != nil:
    section.add "$.xgafv", valid_589070
  var valid_589071 = query.getOrDefault("prettyPrint")
  valid_589071 = validateParameter(valid_589071, JBool, required = false,
                                 default = newJBool(true))
  if valid_589071 != nil:
    section.add "prettyPrint", valid_589071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589072: Call_SpeechProjectsLocationsOperationsGet_589057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_589072.validator(path, query, header, formData, body)
  let scheme = call_589072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589072.url(scheme.get, call_589072.host, call_589072.base,
                         call_589072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589072, url, valid)

proc call*(call_589073: Call_SpeechProjectsLocationsOperationsGet_589057;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## speechProjectsLocationsOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589074 = newJObject()
  var query_589075 = newJObject()
  add(query_589075, "upload_protocol", newJString(uploadProtocol))
  add(query_589075, "fields", newJString(fields))
  add(query_589075, "quotaUser", newJString(quotaUser))
  add(path_589074, "name", newJString(name))
  add(query_589075, "alt", newJString(alt))
  add(query_589075, "oauth_token", newJString(oauthToken))
  add(query_589075, "callback", newJString(callback))
  add(query_589075, "access_token", newJString(accessToken))
  add(query_589075, "uploadType", newJString(uploadType))
  add(query_589075, "key", newJString(key))
  add(query_589075, "$.xgafv", newJString(Xgafv))
  add(query_589075, "prettyPrint", newJBool(prettyPrint))
  result = call_589073.call(path_589074, query_589075, nil, nil, nil)

var speechProjectsLocationsOperationsGet* = Call_SpeechProjectsLocationsOperationsGet_589057(
    name: "speechProjectsLocationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "speech.googleapis.com", route: "/v1/{name}",
    validator: validate_SpeechProjectsLocationsOperationsGet_589058, base: "/",
    url: url_SpeechProjectsLocationsOperationsGet_589059, schemes: {Scheme.Https})
type
  Call_SpeechProjectsLocationsOperationsList_589076 = ref object of OpenApiRestCall_588441
proc url_SpeechProjectsLocationsOperationsList_589078(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpeechProjectsLocationsOperationsList_589077(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation's parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589079 = path.getOrDefault("name")
  valid_589079 = validateParameter(valid_589079, JString, required = true,
                                 default = nil)
  if valid_589079 != nil:
    section.add "name", valid_589079
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_589080 = query.getOrDefault("upload_protocol")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "upload_protocol", valid_589080
  var valid_589081 = query.getOrDefault("fields")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "fields", valid_589081
  var valid_589082 = query.getOrDefault("pageToken")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "pageToken", valid_589082
  var valid_589083 = query.getOrDefault("quotaUser")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "quotaUser", valid_589083
  var valid_589084 = query.getOrDefault("alt")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = newJString("json"))
  if valid_589084 != nil:
    section.add "alt", valid_589084
  var valid_589085 = query.getOrDefault("oauth_token")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "oauth_token", valid_589085
  var valid_589086 = query.getOrDefault("callback")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "callback", valid_589086
  var valid_589087 = query.getOrDefault("access_token")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "access_token", valid_589087
  var valid_589088 = query.getOrDefault("uploadType")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "uploadType", valid_589088
  var valid_589089 = query.getOrDefault("key")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "key", valid_589089
  var valid_589090 = query.getOrDefault("$.xgafv")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString("1"))
  if valid_589090 != nil:
    section.add "$.xgafv", valid_589090
  var valid_589091 = query.getOrDefault("pageSize")
  valid_589091 = validateParameter(valid_589091, JInt, required = false, default = nil)
  if valid_589091 != nil:
    section.add "pageSize", valid_589091
  var valid_589092 = query.getOrDefault("prettyPrint")
  valid_589092 = validateParameter(valid_589092, JBool, required = false,
                                 default = newJBool(true))
  if valid_589092 != nil:
    section.add "prettyPrint", valid_589092
  var valid_589093 = query.getOrDefault("filter")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "filter", valid_589093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589094: Call_SpeechProjectsLocationsOperationsList_589076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_589094.validator(path, query, header, formData, body)
  let scheme = call_589094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589094.url(scheme.get, call_589094.host, call_589094.base,
                         call_589094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589094, url, valid)

proc call*(call_589095: Call_SpeechProjectsLocationsOperationsList_589076;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## speechProjectsLocationsOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
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
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_589096 = newJObject()
  var query_589097 = newJObject()
  add(query_589097, "upload_protocol", newJString(uploadProtocol))
  add(query_589097, "fields", newJString(fields))
  add(query_589097, "pageToken", newJString(pageToken))
  add(query_589097, "quotaUser", newJString(quotaUser))
  add(path_589096, "name", newJString(name))
  add(query_589097, "alt", newJString(alt))
  add(query_589097, "oauth_token", newJString(oauthToken))
  add(query_589097, "callback", newJString(callback))
  add(query_589097, "access_token", newJString(accessToken))
  add(query_589097, "uploadType", newJString(uploadType))
  add(query_589097, "key", newJString(key))
  add(query_589097, "$.xgafv", newJString(Xgafv))
  add(query_589097, "pageSize", newJInt(pageSize))
  add(query_589097, "prettyPrint", newJBool(prettyPrint))
  add(query_589097, "filter", newJString(filter))
  result = call_589095.call(path_589096, query_589097, nil, nil, nil)

var speechProjectsLocationsOperationsList* = Call_SpeechProjectsLocationsOperationsList_589076(
    name: "speechProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "speech.googleapis.com", route: "/v1/{name}/operations",
    validator: validate_SpeechProjectsLocationsOperationsList_589077, base: "/",
    url: url_SpeechProjectsLocationsOperationsList_589078, schemes: {Scheme.Https})
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
