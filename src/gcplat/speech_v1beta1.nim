
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Speech
## version: v1beta1
## termsOfService: (not provided)
## license: (not provided)
## 
## Converts audio to text by applying powerful neural network models.
## 
## https://cloud.google.com/speech/
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
  gcpServiceName = "speech"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SpeechOperationsGet_578610 = ref object of OpenApiRestCall_578339
proc url_SpeechOperationsGet_578612(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/operations/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpeechOperationsGet_578611(path: JsonNode; query: JsonNode;
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
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("pp")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "pp", valid_578753
  var valid_578754 = query.getOrDefault("prettyPrint")
  valid_578754 = validateParameter(valid_578754, JBool, required = false,
                                 default = newJBool(true))
  if valid_578754 != nil:
    section.add "prettyPrint", valid_578754
  var valid_578755 = query.getOrDefault("oauth_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "oauth_token", valid_578755
  var valid_578756 = query.getOrDefault("$.xgafv")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("1"))
  if valid_578756 != nil:
    section.add "$.xgafv", valid_578756
  var valid_578757 = query.getOrDefault("bearer_token")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "bearer_token", valid_578757
  var valid_578758 = query.getOrDefault("alt")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = newJString("json"))
  if valid_578758 != nil:
    section.add "alt", valid_578758
  var valid_578759 = query.getOrDefault("uploadType")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "uploadType", valid_578759
  var valid_578760 = query.getOrDefault("quotaUser")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "quotaUser", valid_578760
  var valid_578761 = query.getOrDefault("callback")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "callback", valid_578761
  var valid_578762 = query.getOrDefault("fields")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "fields", valid_578762
  var valid_578763 = query.getOrDefault("access_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "access_token", valid_578763
  var valid_578764 = query.getOrDefault("upload_protocol")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "upload_protocol", valid_578764
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578787: Call_SpeechOperationsGet_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_578787.validator(path, query, header, formData, body)
  let scheme = call_578787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578787.url(scheme.get, call_578787.host, call_578787.base,
                         call_578787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578787, url, valid)

proc call*(call_578858: Call_SpeechOperationsGet_578610; name: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## speechOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578859 = newJObject()
  var query_578861 = newJObject()
  add(query_578861, "key", newJString(key))
  add(query_578861, "pp", newJBool(pp))
  add(query_578861, "prettyPrint", newJBool(prettyPrint))
  add(query_578861, "oauth_token", newJString(oauthToken))
  add(query_578861, "$.xgafv", newJString(Xgafv))
  add(query_578861, "bearer_token", newJString(bearerToken))
  add(query_578861, "alt", newJString(alt))
  add(query_578861, "uploadType", newJString(uploadType))
  add(query_578861, "quotaUser", newJString(quotaUser))
  add(path_578859, "name", newJString(name))
  add(query_578861, "callback", newJString(callback))
  add(query_578861, "fields", newJString(fields))
  add(query_578861, "access_token", newJString(accessToken))
  add(query_578861, "upload_protocol", newJString(uploadProtocol))
  result = call_578858.call(path_578859, query_578861, nil, nil, nil)

var speechOperationsGet* = Call_SpeechOperationsGet_578610(
    name: "speechOperationsGet", meth: HttpMethod.HttpGet,
    host: "speech.googleapis.com", route: "/v1beta1/operations/{name}",
    validator: validate_SpeechOperationsGet_578611, base: "/",
    url: url_SpeechOperationsGet_578612, schemes: {Scheme.Https})
type
  Call_SpeechSpeechAsyncrecognize_578900 = ref object of OpenApiRestCall_578339
proc url_SpeechSpeechAsyncrecognize_578902(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpeechSpeechAsyncrecognize_578901(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs asynchronous speech recognition: receive results via the
  ## [google.longrunning.Operations]
  ## (/speech/reference/rest/v1beta1/operations#Operation)
  ## interface. Returns either an
  ## `Operation.error` or an `Operation.response` which contains
  ## an `AsyncRecognizeResponse` message.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578903 = query.getOrDefault("key")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "key", valid_578903
  var valid_578904 = query.getOrDefault("pp")
  valid_578904 = validateParameter(valid_578904, JBool, required = false,
                                 default = newJBool(true))
  if valid_578904 != nil:
    section.add "pp", valid_578904
  var valid_578905 = query.getOrDefault("prettyPrint")
  valid_578905 = validateParameter(valid_578905, JBool, required = false,
                                 default = newJBool(true))
  if valid_578905 != nil:
    section.add "prettyPrint", valid_578905
  var valid_578906 = query.getOrDefault("oauth_token")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "oauth_token", valid_578906
  var valid_578907 = query.getOrDefault("$.xgafv")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = newJString("1"))
  if valid_578907 != nil:
    section.add "$.xgafv", valid_578907
  var valid_578908 = query.getOrDefault("bearer_token")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "bearer_token", valid_578908
  var valid_578909 = query.getOrDefault("alt")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("json"))
  if valid_578909 != nil:
    section.add "alt", valid_578909
  var valid_578910 = query.getOrDefault("uploadType")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "uploadType", valid_578910
  var valid_578911 = query.getOrDefault("quotaUser")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "quotaUser", valid_578911
  var valid_578912 = query.getOrDefault("callback")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "callback", valid_578912
  var valid_578913 = query.getOrDefault("fields")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "fields", valid_578913
  var valid_578914 = query.getOrDefault("access_token")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "access_token", valid_578914
  var valid_578915 = query.getOrDefault("upload_protocol")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "upload_protocol", valid_578915
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

proc call*(call_578917: Call_SpeechSpeechAsyncrecognize_578900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs asynchronous speech recognition: receive results via the
  ## [google.longrunning.Operations]
  ## (/speech/reference/rest/v1beta1/operations#Operation)
  ## interface. Returns either an
  ## `Operation.error` or an `Operation.response` which contains
  ## an `AsyncRecognizeResponse` message.
  ## 
  let valid = call_578917.validator(path, query, header, formData, body)
  let scheme = call_578917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578917.url(scheme.get, call_578917.host, call_578917.base,
                         call_578917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578917, url, valid)

proc call*(call_578918: Call_SpeechSpeechAsyncrecognize_578900; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## speechSpeechAsyncrecognize
  ## Performs asynchronous speech recognition: receive results via the
  ## [google.longrunning.Operations]
  ## (/speech/reference/rest/v1beta1/operations#Operation)
  ## interface. Returns either an
  ## `Operation.error` or an `Operation.response` which contains
  ## an `AsyncRecognizeResponse` message.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var query_578919 = newJObject()
  var body_578920 = newJObject()
  add(query_578919, "key", newJString(key))
  add(query_578919, "pp", newJBool(pp))
  add(query_578919, "prettyPrint", newJBool(prettyPrint))
  add(query_578919, "oauth_token", newJString(oauthToken))
  add(query_578919, "$.xgafv", newJString(Xgafv))
  add(query_578919, "bearer_token", newJString(bearerToken))
  add(query_578919, "alt", newJString(alt))
  add(query_578919, "uploadType", newJString(uploadType))
  add(query_578919, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578920 = body
  add(query_578919, "callback", newJString(callback))
  add(query_578919, "fields", newJString(fields))
  add(query_578919, "access_token", newJString(accessToken))
  add(query_578919, "upload_protocol", newJString(uploadProtocol))
  result = call_578918.call(nil, query_578919, nil, nil, body_578920)

var speechSpeechAsyncrecognize* = Call_SpeechSpeechAsyncrecognize_578900(
    name: "speechSpeechAsyncrecognize", meth: HttpMethod.HttpPost,
    host: "speech.googleapis.com", route: "/v1beta1/speech:asyncrecognize",
    validator: validate_SpeechSpeechAsyncrecognize_578901, base: "/",
    url: url_SpeechSpeechAsyncrecognize_578902, schemes: {Scheme.Https})
type
  Call_SpeechSpeechSyncrecognize_578921 = ref object of OpenApiRestCall_578339
proc url_SpeechSpeechSyncrecognize_578923(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpeechSpeechSyncrecognize_578922(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs synchronous speech recognition: receive results after all audio
  ## has been sent and processed.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578924 = query.getOrDefault("key")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "key", valid_578924
  var valid_578925 = query.getOrDefault("pp")
  valid_578925 = validateParameter(valid_578925, JBool, required = false,
                                 default = newJBool(true))
  if valid_578925 != nil:
    section.add "pp", valid_578925
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
  var valid_578929 = query.getOrDefault("bearer_token")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "bearer_token", valid_578929
  var valid_578930 = query.getOrDefault("alt")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("json"))
  if valid_578930 != nil:
    section.add "alt", valid_578930
  var valid_578931 = query.getOrDefault("uploadType")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "uploadType", valid_578931
  var valid_578932 = query.getOrDefault("quotaUser")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "quotaUser", valid_578932
  var valid_578933 = query.getOrDefault("callback")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "callback", valid_578933
  var valid_578934 = query.getOrDefault("fields")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "fields", valid_578934
  var valid_578935 = query.getOrDefault("access_token")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "access_token", valid_578935
  var valid_578936 = query.getOrDefault("upload_protocol")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "upload_protocol", valid_578936
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

proc call*(call_578938: Call_SpeechSpeechSyncrecognize_578921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs synchronous speech recognition: receive results after all audio
  ## has been sent and processed.
  ## 
  let valid = call_578938.validator(path, query, header, formData, body)
  let scheme = call_578938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578938.url(scheme.get, call_578938.host, call_578938.base,
                         call_578938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578938, url, valid)

proc call*(call_578939: Call_SpeechSpeechSyncrecognize_578921; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## speechSpeechSyncrecognize
  ## Performs synchronous speech recognition: receive results after all audio
  ## has been sent and processed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var query_578940 = newJObject()
  var body_578941 = newJObject()
  add(query_578940, "key", newJString(key))
  add(query_578940, "pp", newJBool(pp))
  add(query_578940, "prettyPrint", newJBool(prettyPrint))
  add(query_578940, "oauth_token", newJString(oauthToken))
  add(query_578940, "$.xgafv", newJString(Xgafv))
  add(query_578940, "bearer_token", newJString(bearerToken))
  add(query_578940, "alt", newJString(alt))
  add(query_578940, "uploadType", newJString(uploadType))
  add(query_578940, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578941 = body
  add(query_578940, "callback", newJString(callback))
  add(query_578940, "fields", newJString(fields))
  add(query_578940, "access_token", newJString(accessToken))
  add(query_578940, "upload_protocol", newJString(uploadProtocol))
  result = call_578939.call(nil, query_578940, nil, nil, body_578941)

var speechSpeechSyncrecognize* = Call_SpeechSpeechSyncrecognize_578921(
    name: "speechSpeechSyncrecognize", meth: HttpMethod.HttpPost,
    host: "speech.googleapis.com", route: "/v1beta1/speech:syncrecognize",
    validator: validate_SpeechSpeechSyncrecognize_578922, base: "/",
    url: url_SpeechSpeechSyncrecognize_578923, schemes: {Scheme.Https})
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
