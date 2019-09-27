
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SpeechOperationsList_593677 = ref object of OpenApiRestCall_593408
proc url_SpeechOperationsList_593679(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SpeechOperationsList_593678(path: JsonNode; query: JsonNode;
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
  var valid_593791 = query.getOrDefault("upload_protocol")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "upload_protocol", valid_593791
  var valid_593792 = query.getOrDefault("fields")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "fields", valid_593792
  var valid_593793 = query.getOrDefault("pageToken")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "pageToken", valid_593793
  var valid_593794 = query.getOrDefault("quotaUser")
  valid_593794 = validateParameter(valid_593794, JString, required = false,
                                 default = nil)
  if valid_593794 != nil:
    section.add "quotaUser", valid_593794
  var valid_593808 = query.getOrDefault("alt")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = newJString("json"))
  if valid_593808 != nil:
    section.add "alt", valid_593808
  var valid_593809 = query.getOrDefault("oauth_token")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "oauth_token", valid_593809
  var valid_593810 = query.getOrDefault("callback")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "callback", valid_593810
  var valid_593811 = query.getOrDefault("access_token")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "access_token", valid_593811
  var valid_593812 = query.getOrDefault("uploadType")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "uploadType", valid_593812
  var valid_593813 = query.getOrDefault("key")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "key", valid_593813
  var valid_593814 = query.getOrDefault("name")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "name", valid_593814
  var valid_593815 = query.getOrDefault("$.xgafv")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = newJString("1"))
  if valid_593815 != nil:
    section.add "$.xgafv", valid_593815
  var valid_593816 = query.getOrDefault("pageSize")
  valid_593816 = validateParameter(valid_593816, JInt, required = false, default = nil)
  if valid_593816 != nil:
    section.add "pageSize", valid_593816
  var valid_593817 = query.getOrDefault("prettyPrint")
  valid_593817 = validateParameter(valid_593817, JBool, required = false,
                                 default = newJBool(true))
  if valid_593817 != nil:
    section.add "prettyPrint", valid_593817
  var valid_593818 = query.getOrDefault("filter")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = nil)
  if valid_593818 != nil:
    section.add "filter", valid_593818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593841: Call_SpeechOperationsList_593677; path: JsonNode;
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
  let valid = call_593841.validator(path, query, header, formData, body)
  let scheme = call_593841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593841.url(scheme.get, call_593841.host, call_593841.base,
                         call_593841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593841, url, valid)

proc call*(call_593912: Call_SpeechOperationsList_593677;
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
  var query_593913 = newJObject()
  add(query_593913, "upload_protocol", newJString(uploadProtocol))
  add(query_593913, "fields", newJString(fields))
  add(query_593913, "pageToken", newJString(pageToken))
  add(query_593913, "quotaUser", newJString(quotaUser))
  add(query_593913, "alt", newJString(alt))
  add(query_593913, "oauth_token", newJString(oauthToken))
  add(query_593913, "callback", newJString(callback))
  add(query_593913, "access_token", newJString(accessToken))
  add(query_593913, "uploadType", newJString(uploadType))
  add(query_593913, "key", newJString(key))
  add(query_593913, "name", newJString(name))
  add(query_593913, "$.xgafv", newJString(Xgafv))
  add(query_593913, "pageSize", newJInt(pageSize))
  add(query_593913, "prettyPrint", newJBool(prettyPrint))
  add(query_593913, "filter", newJString(filter))
  result = call_593912.call(nil, query_593913, nil, nil, nil)

var speechOperationsList* = Call_SpeechOperationsList_593677(
    name: "speechOperationsList", meth: HttpMethod.HttpGet,
    host: "speech.googleapis.com", route: "/v1/operations",
    validator: validate_SpeechOperationsList_593678, base: "/",
    url: url_SpeechOperationsList_593679, schemes: {Scheme.Https})
type
  Call_SpeechOperationsGet_593953 = ref object of OpenApiRestCall_593408
proc url_SpeechOperationsGet_593955(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/operations/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpeechOperationsGet_593954(path: JsonNode; query: JsonNode;
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
  var valid_593970 = path.getOrDefault("name")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "name", valid_593970
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
  var valid_593971 = query.getOrDefault("upload_protocol")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "upload_protocol", valid_593971
  var valid_593972 = query.getOrDefault("fields")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "fields", valid_593972
  var valid_593973 = query.getOrDefault("quotaUser")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "quotaUser", valid_593973
  var valid_593974 = query.getOrDefault("alt")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = newJString("json"))
  if valid_593974 != nil:
    section.add "alt", valid_593974
  var valid_593975 = query.getOrDefault("oauth_token")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "oauth_token", valid_593975
  var valid_593976 = query.getOrDefault("callback")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "callback", valid_593976
  var valid_593977 = query.getOrDefault("access_token")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "access_token", valid_593977
  var valid_593978 = query.getOrDefault("uploadType")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "uploadType", valid_593978
  var valid_593979 = query.getOrDefault("key")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "key", valid_593979
  var valid_593980 = query.getOrDefault("$.xgafv")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = newJString("1"))
  if valid_593980 != nil:
    section.add "$.xgafv", valid_593980
  var valid_593981 = query.getOrDefault("prettyPrint")
  valid_593981 = validateParameter(valid_593981, JBool, required = false,
                                 default = newJBool(true))
  if valid_593981 != nil:
    section.add "prettyPrint", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_SpeechOperationsGet_593953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_SpeechOperationsGet_593953; name: string;
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
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  add(query_593985, "upload_protocol", newJString(uploadProtocol))
  add(query_593985, "fields", newJString(fields))
  add(query_593985, "quotaUser", newJString(quotaUser))
  add(path_593984, "name", newJString(name))
  add(query_593985, "alt", newJString(alt))
  add(query_593985, "oauth_token", newJString(oauthToken))
  add(query_593985, "callback", newJString(callback))
  add(query_593985, "access_token", newJString(accessToken))
  add(query_593985, "uploadType", newJString(uploadType))
  add(query_593985, "key", newJString(key))
  add(query_593985, "$.xgafv", newJString(Xgafv))
  add(query_593985, "prettyPrint", newJBool(prettyPrint))
  result = call_593983.call(path_593984, query_593985, nil, nil, nil)

var speechOperationsGet* = Call_SpeechOperationsGet_593953(
    name: "speechOperationsGet", meth: HttpMethod.HttpGet,
    host: "speech.googleapis.com", route: "/v1/operations/{name}",
    validator: validate_SpeechOperationsGet_593954, base: "/",
    url: url_SpeechOperationsGet_593955, schemes: {Scheme.Https})
type
  Call_SpeechSpeechLongrunningrecognize_593986 = ref object of OpenApiRestCall_593408
proc url_SpeechSpeechLongrunningrecognize_593988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SpeechSpeechLongrunningrecognize_593987(path: JsonNode;
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
  var valid_593989 = query.getOrDefault("upload_protocol")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "upload_protocol", valid_593989
  var valid_593990 = query.getOrDefault("fields")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "fields", valid_593990
  var valid_593991 = query.getOrDefault("quotaUser")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "quotaUser", valid_593991
  var valid_593992 = query.getOrDefault("alt")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = newJString("json"))
  if valid_593992 != nil:
    section.add "alt", valid_593992
  var valid_593993 = query.getOrDefault("oauth_token")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "oauth_token", valid_593993
  var valid_593994 = query.getOrDefault("callback")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "callback", valid_593994
  var valid_593995 = query.getOrDefault("access_token")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "access_token", valid_593995
  var valid_593996 = query.getOrDefault("uploadType")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "uploadType", valid_593996
  var valid_593997 = query.getOrDefault("key")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "key", valid_593997
  var valid_593998 = query.getOrDefault("$.xgafv")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = newJString("1"))
  if valid_593998 != nil:
    section.add "$.xgafv", valid_593998
  var valid_593999 = query.getOrDefault("prettyPrint")
  valid_593999 = validateParameter(valid_593999, JBool, required = false,
                                 default = newJBool(true))
  if valid_593999 != nil:
    section.add "prettyPrint", valid_593999
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

proc call*(call_594001: Call_SpeechSpeechLongrunningrecognize_593986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs asynchronous speech recognition: receive results via the
  ## google.longrunning.Operations interface. Returns either an
  ## `Operation.error` or an `Operation.response` which contains
  ## a `LongRunningRecognizeResponse` message.
  ## For more information on asynchronous speech recognition, see the
  ## [how-to](https://cloud.google.com/speech-to-text/docs/async-recognize).
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_SpeechSpeechLongrunningrecognize_593986;
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
  var query_594003 = newJObject()
  var body_594004 = newJObject()
  add(query_594003, "upload_protocol", newJString(uploadProtocol))
  add(query_594003, "fields", newJString(fields))
  add(query_594003, "quotaUser", newJString(quotaUser))
  add(query_594003, "alt", newJString(alt))
  add(query_594003, "oauth_token", newJString(oauthToken))
  add(query_594003, "callback", newJString(callback))
  add(query_594003, "access_token", newJString(accessToken))
  add(query_594003, "uploadType", newJString(uploadType))
  add(query_594003, "key", newJString(key))
  add(query_594003, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594004 = body
  add(query_594003, "prettyPrint", newJBool(prettyPrint))
  result = call_594002.call(nil, query_594003, nil, nil, body_594004)

var speechSpeechLongrunningrecognize* = Call_SpeechSpeechLongrunningrecognize_593986(
    name: "speechSpeechLongrunningrecognize", meth: HttpMethod.HttpPost,
    host: "speech.googleapis.com", route: "/v1/speech:longrunningrecognize",
    validator: validate_SpeechSpeechLongrunningrecognize_593987, base: "/",
    url: url_SpeechSpeechLongrunningrecognize_593988, schemes: {Scheme.Https})
type
  Call_SpeechSpeechRecognize_594005 = ref object of OpenApiRestCall_593408
proc url_SpeechSpeechRecognize_594007(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SpeechSpeechRecognize_594006(path: JsonNode; query: JsonNode;
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
  var valid_594008 = query.getOrDefault("upload_protocol")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "upload_protocol", valid_594008
  var valid_594009 = query.getOrDefault("fields")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "fields", valid_594009
  var valid_594010 = query.getOrDefault("quotaUser")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "quotaUser", valid_594010
  var valid_594011 = query.getOrDefault("alt")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = newJString("json"))
  if valid_594011 != nil:
    section.add "alt", valid_594011
  var valid_594012 = query.getOrDefault("oauth_token")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "oauth_token", valid_594012
  var valid_594013 = query.getOrDefault("callback")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "callback", valid_594013
  var valid_594014 = query.getOrDefault("access_token")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "access_token", valid_594014
  var valid_594015 = query.getOrDefault("uploadType")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "uploadType", valid_594015
  var valid_594016 = query.getOrDefault("key")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "key", valid_594016
  var valid_594017 = query.getOrDefault("$.xgafv")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = newJString("1"))
  if valid_594017 != nil:
    section.add "$.xgafv", valid_594017
  var valid_594018 = query.getOrDefault("prettyPrint")
  valid_594018 = validateParameter(valid_594018, JBool, required = false,
                                 default = newJBool(true))
  if valid_594018 != nil:
    section.add "prettyPrint", valid_594018
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

proc call*(call_594020: Call_SpeechSpeechRecognize_594005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Performs synchronous speech recognition: receive results after all audio
  ## has been sent and processed.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_SpeechSpeechRecognize_594005;
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
  var query_594022 = newJObject()
  var body_594023 = newJObject()
  add(query_594022, "upload_protocol", newJString(uploadProtocol))
  add(query_594022, "fields", newJString(fields))
  add(query_594022, "quotaUser", newJString(quotaUser))
  add(query_594022, "alt", newJString(alt))
  add(query_594022, "oauth_token", newJString(oauthToken))
  add(query_594022, "callback", newJString(callback))
  add(query_594022, "access_token", newJString(accessToken))
  add(query_594022, "uploadType", newJString(uploadType))
  add(query_594022, "key", newJString(key))
  add(query_594022, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594023 = body
  add(query_594022, "prettyPrint", newJBool(prettyPrint))
  result = call_594021.call(nil, query_594022, nil, nil, body_594023)

var speechSpeechRecognize* = Call_SpeechSpeechRecognize_594005(
    name: "speechSpeechRecognize", meth: HttpMethod.HttpPost,
    host: "speech.googleapis.com", route: "/v1/speech:recognize",
    validator: validate_SpeechSpeechRecognize_594006, base: "/",
    url: url_SpeechSpeechRecognize_594007, schemes: {Scheme.Https})
type
  Call_SpeechProjectsLocationsOperationsGet_594024 = ref object of OpenApiRestCall_593408
proc url_SpeechProjectsLocationsOperationsGet_594026(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpeechProjectsLocationsOperationsGet_594025(path: JsonNode;
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
  var valid_594027 = path.getOrDefault("name")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "name", valid_594027
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
  var valid_594028 = query.getOrDefault("upload_protocol")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "upload_protocol", valid_594028
  var valid_594029 = query.getOrDefault("fields")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "fields", valid_594029
  var valid_594030 = query.getOrDefault("quotaUser")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "quotaUser", valid_594030
  var valid_594031 = query.getOrDefault("alt")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = newJString("json"))
  if valid_594031 != nil:
    section.add "alt", valid_594031
  var valid_594032 = query.getOrDefault("oauth_token")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "oauth_token", valid_594032
  var valid_594033 = query.getOrDefault("callback")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "callback", valid_594033
  var valid_594034 = query.getOrDefault("access_token")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "access_token", valid_594034
  var valid_594035 = query.getOrDefault("uploadType")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "uploadType", valid_594035
  var valid_594036 = query.getOrDefault("key")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "key", valid_594036
  var valid_594037 = query.getOrDefault("$.xgafv")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = newJString("1"))
  if valid_594037 != nil:
    section.add "$.xgafv", valid_594037
  var valid_594038 = query.getOrDefault("prettyPrint")
  valid_594038 = validateParameter(valid_594038, JBool, required = false,
                                 default = newJBool(true))
  if valid_594038 != nil:
    section.add "prettyPrint", valid_594038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594039: Call_SpeechProjectsLocationsOperationsGet_594024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_SpeechProjectsLocationsOperationsGet_594024;
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
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  add(query_594042, "upload_protocol", newJString(uploadProtocol))
  add(query_594042, "fields", newJString(fields))
  add(query_594042, "quotaUser", newJString(quotaUser))
  add(path_594041, "name", newJString(name))
  add(query_594042, "alt", newJString(alt))
  add(query_594042, "oauth_token", newJString(oauthToken))
  add(query_594042, "callback", newJString(callback))
  add(query_594042, "access_token", newJString(accessToken))
  add(query_594042, "uploadType", newJString(uploadType))
  add(query_594042, "key", newJString(key))
  add(query_594042, "$.xgafv", newJString(Xgafv))
  add(query_594042, "prettyPrint", newJBool(prettyPrint))
  result = call_594040.call(path_594041, query_594042, nil, nil, nil)

var speechProjectsLocationsOperationsGet* = Call_SpeechProjectsLocationsOperationsGet_594024(
    name: "speechProjectsLocationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "speech.googleapis.com", route: "/v1/{name}",
    validator: validate_SpeechProjectsLocationsOperationsGet_594025, base: "/",
    url: url_SpeechProjectsLocationsOperationsGet_594026, schemes: {Scheme.Https})
type
  Call_SpeechProjectsLocationsOperationsList_594043 = ref object of OpenApiRestCall_593408
proc url_SpeechProjectsLocationsOperationsList_594045(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SpeechProjectsLocationsOperationsList_594044(path: JsonNode;
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
  var valid_594046 = path.getOrDefault("name")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "name", valid_594046
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
  var valid_594047 = query.getOrDefault("upload_protocol")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "upload_protocol", valid_594047
  var valid_594048 = query.getOrDefault("fields")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "fields", valid_594048
  var valid_594049 = query.getOrDefault("pageToken")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "pageToken", valid_594049
  var valid_594050 = query.getOrDefault("quotaUser")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "quotaUser", valid_594050
  var valid_594051 = query.getOrDefault("alt")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = newJString("json"))
  if valid_594051 != nil:
    section.add "alt", valid_594051
  var valid_594052 = query.getOrDefault("oauth_token")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "oauth_token", valid_594052
  var valid_594053 = query.getOrDefault("callback")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "callback", valid_594053
  var valid_594054 = query.getOrDefault("access_token")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "access_token", valid_594054
  var valid_594055 = query.getOrDefault("uploadType")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "uploadType", valid_594055
  var valid_594056 = query.getOrDefault("key")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "key", valid_594056
  var valid_594057 = query.getOrDefault("$.xgafv")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = newJString("1"))
  if valid_594057 != nil:
    section.add "$.xgafv", valid_594057
  var valid_594058 = query.getOrDefault("pageSize")
  valid_594058 = validateParameter(valid_594058, JInt, required = false, default = nil)
  if valid_594058 != nil:
    section.add "pageSize", valid_594058
  var valid_594059 = query.getOrDefault("prettyPrint")
  valid_594059 = validateParameter(valid_594059, JBool, required = false,
                                 default = newJBool(true))
  if valid_594059 != nil:
    section.add "prettyPrint", valid_594059
  var valid_594060 = query.getOrDefault("filter")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "filter", valid_594060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594061: Call_SpeechProjectsLocationsOperationsList_594043;
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
  let valid = call_594061.validator(path, query, header, formData, body)
  let scheme = call_594061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594061.url(scheme.get, call_594061.host, call_594061.base,
                         call_594061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594061, url, valid)

proc call*(call_594062: Call_SpeechProjectsLocationsOperationsList_594043;
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
  var path_594063 = newJObject()
  var query_594064 = newJObject()
  add(query_594064, "upload_protocol", newJString(uploadProtocol))
  add(query_594064, "fields", newJString(fields))
  add(query_594064, "pageToken", newJString(pageToken))
  add(query_594064, "quotaUser", newJString(quotaUser))
  add(path_594063, "name", newJString(name))
  add(query_594064, "alt", newJString(alt))
  add(query_594064, "oauth_token", newJString(oauthToken))
  add(query_594064, "callback", newJString(callback))
  add(query_594064, "access_token", newJString(accessToken))
  add(query_594064, "uploadType", newJString(uploadType))
  add(query_594064, "key", newJString(key))
  add(query_594064, "$.xgafv", newJString(Xgafv))
  add(query_594064, "pageSize", newJInt(pageSize))
  add(query_594064, "prettyPrint", newJBool(prettyPrint))
  add(query_594064, "filter", newJString(filter))
  result = call_594062.call(path_594063, query_594064, nil, nil, nil)

var speechProjectsLocationsOperationsList* = Call_SpeechProjectsLocationsOperationsList_594043(
    name: "speechProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "speech.googleapis.com", route: "/v1/{name}/operations",
    validator: validate_SpeechProjectsLocationsOperationsList_594044, base: "/",
    url: url_SpeechProjectsLocationsOperationsList_594045, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
