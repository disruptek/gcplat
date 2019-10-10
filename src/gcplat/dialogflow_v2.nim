
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Dialogflow
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Builds conversational interfaces (for example, chatbots, and voice-powered apps and devices).
## 
## https://cloud.google.com/dialogflow/
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "dialogflow"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DialogflowProjectsLocationsOperationsGet_588719 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsLocationsOperationsGet_588721(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsLocationsOperationsGet_588720(path: JsonNode;
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
  var valid_588847 = path.getOrDefault("name")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "name", valid_588847
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
  ##   intentView: JString
  ##             : Optional. The resource view to apply to the returned intent.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   languageCode: JString
  ##               : Optional. The language to retrieve training phrases, parameters and rich
  ## messages for. If not specified, the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588848 = query.getOrDefault("upload_protocol")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "upload_protocol", valid_588848
  var valid_588849 = query.getOrDefault("fields")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "fields", valid_588849
  var valid_588850 = query.getOrDefault("quotaUser")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "quotaUser", valid_588850
  var valid_588864 = query.getOrDefault("alt")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = newJString("json"))
  if valid_588864 != nil:
    section.add "alt", valid_588864
  var valid_588865 = query.getOrDefault("oauth_token")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "oauth_token", valid_588865
  var valid_588866 = query.getOrDefault("callback")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "callback", valid_588866
  var valid_588867 = query.getOrDefault("access_token")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "access_token", valid_588867
  var valid_588868 = query.getOrDefault("uploadType")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "uploadType", valid_588868
  var valid_588869 = query.getOrDefault("intentView")
  valid_588869 = validateParameter(valid_588869, JString, required = false, default = newJString(
      "INTENT_VIEW_UNSPECIFIED"))
  if valid_588869 != nil:
    section.add "intentView", valid_588869
  var valid_588870 = query.getOrDefault("key")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = nil)
  if valid_588870 != nil:
    section.add "key", valid_588870
  var valid_588871 = query.getOrDefault("$.xgafv")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = newJString("1"))
  if valid_588871 != nil:
    section.add "$.xgafv", valid_588871
  var valid_588872 = query.getOrDefault("languageCode")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "languageCode", valid_588872
  var valid_588873 = query.getOrDefault("prettyPrint")
  valid_588873 = validateParameter(valid_588873, JBool, required = false,
                                 default = newJBool(true))
  if valid_588873 != nil:
    section.add "prettyPrint", valid_588873
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588896: Call_DialogflowProjectsLocationsOperationsGet_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_588896.validator(path, query, header, formData, body)
  let scheme = call_588896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588896.url(scheme.get, call_588896.host, call_588896.base,
                         call_588896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588896, url, valid)

proc call*(call_588967: Call_DialogflowProjectsLocationsOperationsGet_588719;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          intentView: string = "INTENT_VIEW_UNSPECIFIED"; key: string = "";
          Xgafv: string = "1"; languageCode: string = ""; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsLocationsOperationsGet
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
  ##   intentView: string
  ##             : Optional. The resource view to apply to the returned intent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCode: string
  ##               : Optional. The language to retrieve training phrases, parameters and rich
  ## messages for. If not specified, the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_588968 = newJObject()
  var query_588970 = newJObject()
  add(query_588970, "upload_protocol", newJString(uploadProtocol))
  add(query_588970, "fields", newJString(fields))
  add(query_588970, "quotaUser", newJString(quotaUser))
  add(path_588968, "name", newJString(name))
  add(query_588970, "alt", newJString(alt))
  add(query_588970, "oauth_token", newJString(oauthToken))
  add(query_588970, "callback", newJString(callback))
  add(query_588970, "access_token", newJString(accessToken))
  add(query_588970, "uploadType", newJString(uploadType))
  add(query_588970, "intentView", newJString(intentView))
  add(query_588970, "key", newJString(key))
  add(query_588970, "$.xgafv", newJString(Xgafv))
  add(query_588970, "languageCode", newJString(languageCode))
  add(query_588970, "prettyPrint", newJBool(prettyPrint))
  result = call_588967.call(path_588968, query_588970, nil, nil, nil)

var dialogflowProjectsLocationsOperationsGet* = Call_DialogflowProjectsLocationsOperationsGet_588719(
    name: "dialogflowProjectsLocationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{name}",
    validator: validate_DialogflowProjectsLocationsOperationsGet_588720,
    base: "/", url: url_DialogflowProjectsLocationsOperationsGet_588721,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentIntentsPatch_589028 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentIntentsPatch_589030(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentIntentsPatch_589029(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified intent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique identifier of this intent.
  ## Required for Intents.UpdateIntent and Intents.BatchUpdateIntents
  ## methods.
  ## Format: `projects/<Project ID>/agent/intents/<Intent ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589031 = path.getOrDefault("name")
  valid_589031 = validateParameter(valid_589031, JString, required = true,
                                 default = nil)
  if valid_589031 != nil:
    section.add "name", valid_589031
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
  ##   intentView: JString
  ##             : Optional. The resource view to apply to the returned intent.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   languageCode: JString
  ##               : Optional. The language of training phrases, parameters and rich messages
  ## defined in `intent`. If not specified, the agent's default language is
  ## used. [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Optional. The mask to control which fields get updated.
  section = newJObject()
  var valid_589032 = query.getOrDefault("upload_protocol")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "upload_protocol", valid_589032
  var valid_589033 = query.getOrDefault("fields")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "fields", valid_589033
  var valid_589034 = query.getOrDefault("quotaUser")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "quotaUser", valid_589034
  var valid_589035 = query.getOrDefault("alt")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = newJString("json"))
  if valid_589035 != nil:
    section.add "alt", valid_589035
  var valid_589036 = query.getOrDefault("oauth_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "oauth_token", valid_589036
  var valid_589037 = query.getOrDefault("callback")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "callback", valid_589037
  var valid_589038 = query.getOrDefault("access_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "access_token", valid_589038
  var valid_589039 = query.getOrDefault("uploadType")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "uploadType", valid_589039
  var valid_589040 = query.getOrDefault("intentView")
  valid_589040 = validateParameter(valid_589040, JString, required = false, default = newJString(
      "INTENT_VIEW_UNSPECIFIED"))
  if valid_589040 != nil:
    section.add "intentView", valid_589040
  var valid_589041 = query.getOrDefault("key")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "key", valid_589041
  var valid_589042 = query.getOrDefault("$.xgafv")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("1"))
  if valid_589042 != nil:
    section.add "$.xgafv", valid_589042
  var valid_589043 = query.getOrDefault("languageCode")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "languageCode", valid_589043
  var valid_589044 = query.getOrDefault("prettyPrint")
  valid_589044 = validateParameter(valid_589044, JBool, required = false,
                                 default = newJBool(true))
  if valid_589044 != nil:
    section.add "prettyPrint", valid_589044
  var valid_589045 = query.getOrDefault("updateMask")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "updateMask", valid_589045
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

proc call*(call_589047: Call_DialogflowProjectsAgentIntentsPatch_589028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified intent.
  ## 
  let valid = call_589047.validator(path, query, header, formData, body)
  let scheme = call_589047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589047.url(scheme.get, call_589047.host, call_589047.base,
                         call_589047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589047, url, valid)

proc call*(call_589048: Call_DialogflowProjectsAgentIntentsPatch_589028;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          intentView: string = "INTENT_VIEW_UNSPECIFIED"; key: string = "";
          Xgafv: string = "1"; languageCode: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## dialogflowProjectsAgentIntentsPatch
  ## Updates the specified intent.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The unique identifier of this intent.
  ## Required for Intents.UpdateIntent and Intents.BatchUpdateIntents
  ## methods.
  ## Format: `projects/<Project ID>/agent/intents/<Intent ID>`.
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
  ##   intentView: string
  ##             : Optional. The resource view to apply to the returned intent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCode: string
  ##               : Optional. The language of training phrases, parameters and rich messages
  ## defined in `intent`. If not specified, the agent's default language is
  ## used. [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Optional. The mask to control which fields get updated.
  var path_589049 = newJObject()
  var query_589050 = newJObject()
  var body_589051 = newJObject()
  add(query_589050, "upload_protocol", newJString(uploadProtocol))
  add(query_589050, "fields", newJString(fields))
  add(query_589050, "quotaUser", newJString(quotaUser))
  add(path_589049, "name", newJString(name))
  add(query_589050, "alt", newJString(alt))
  add(query_589050, "oauth_token", newJString(oauthToken))
  add(query_589050, "callback", newJString(callback))
  add(query_589050, "access_token", newJString(accessToken))
  add(query_589050, "uploadType", newJString(uploadType))
  add(query_589050, "intentView", newJString(intentView))
  add(query_589050, "key", newJString(key))
  add(query_589050, "$.xgafv", newJString(Xgafv))
  add(query_589050, "languageCode", newJString(languageCode))
  if body != nil:
    body_589051 = body
  add(query_589050, "prettyPrint", newJBool(prettyPrint))
  add(query_589050, "updateMask", newJString(updateMask))
  result = call_589048.call(path_589049, query_589050, nil, nil, body_589051)

var dialogflowProjectsAgentIntentsPatch* = Call_DialogflowProjectsAgentIntentsPatch_589028(
    name: "dialogflowProjectsAgentIntentsPatch", meth: HttpMethod.HttpPatch,
    host: "dialogflow.googleapis.com", route: "/v2/{name}",
    validator: validate_DialogflowProjectsAgentIntentsPatch_589029, base: "/",
    url: url_DialogflowProjectsAgentIntentsPatch_589030, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentIntentsDelete_589009 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentIntentsDelete_589011(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentIntentsDelete_589010(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified intent and its direct or indirect followup intents.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the intent to delete. If this intent has direct or
  ## indirect followup intents, we also delete them.
  ## Format: `projects/<Project ID>/agent/intents/<Intent ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589012 = path.getOrDefault("name")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "name", valid_589012
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
  var valid_589013 = query.getOrDefault("upload_protocol")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "upload_protocol", valid_589013
  var valid_589014 = query.getOrDefault("fields")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "fields", valid_589014
  var valid_589015 = query.getOrDefault("quotaUser")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "quotaUser", valid_589015
  var valid_589016 = query.getOrDefault("alt")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("json"))
  if valid_589016 != nil:
    section.add "alt", valid_589016
  var valid_589017 = query.getOrDefault("oauth_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "oauth_token", valid_589017
  var valid_589018 = query.getOrDefault("callback")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "callback", valid_589018
  var valid_589019 = query.getOrDefault("access_token")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "access_token", valid_589019
  var valid_589020 = query.getOrDefault("uploadType")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "uploadType", valid_589020
  var valid_589021 = query.getOrDefault("key")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "key", valid_589021
  var valid_589022 = query.getOrDefault("$.xgafv")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = newJString("1"))
  if valid_589022 != nil:
    section.add "$.xgafv", valid_589022
  var valid_589023 = query.getOrDefault("prettyPrint")
  valid_589023 = validateParameter(valid_589023, JBool, required = false,
                                 default = newJBool(true))
  if valid_589023 != nil:
    section.add "prettyPrint", valid_589023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589024: Call_DialogflowProjectsAgentIntentsDelete_589009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified intent and its direct or indirect followup intents.
  ## 
  let valid = call_589024.validator(path, query, header, formData, body)
  let scheme = call_589024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589024.url(scheme.get, call_589024.host, call_589024.base,
                         call_589024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589024, url, valid)

proc call*(call_589025: Call_DialogflowProjectsAgentIntentsDelete_589009;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentIntentsDelete
  ## Deletes the specified intent and its direct or indirect followup intents.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the intent to delete. If this intent has direct or
  ## indirect followup intents, we also delete them.
  ## Format: `projects/<Project ID>/agent/intents/<Intent ID>`.
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
  var path_589026 = newJObject()
  var query_589027 = newJObject()
  add(query_589027, "upload_protocol", newJString(uploadProtocol))
  add(query_589027, "fields", newJString(fields))
  add(query_589027, "quotaUser", newJString(quotaUser))
  add(path_589026, "name", newJString(name))
  add(query_589027, "alt", newJString(alt))
  add(query_589027, "oauth_token", newJString(oauthToken))
  add(query_589027, "callback", newJString(callback))
  add(query_589027, "access_token", newJString(accessToken))
  add(query_589027, "uploadType", newJString(uploadType))
  add(query_589027, "key", newJString(key))
  add(query_589027, "$.xgafv", newJString(Xgafv))
  add(query_589027, "prettyPrint", newJBool(prettyPrint))
  result = call_589025.call(path_589026, query_589027, nil, nil, nil)

var dialogflowProjectsAgentIntentsDelete* = Call_DialogflowProjectsAgentIntentsDelete_589009(
    name: "dialogflowProjectsAgentIntentsDelete", meth: HttpMethod.HttpDelete,
    host: "dialogflow.googleapis.com", route: "/v2/{name}",
    validator: validate_DialogflowProjectsAgentIntentsDelete_589010, base: "/",
    url: url_DialogflowProjectsAgentIntentsDelete_589011, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsLocationsOperationsList_589052 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsLocationsOperationsList_589054(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsLocationsOperationsList_589053(path: JsonNode;
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
  var valid_589055 = path.getOrDefault("name")
  valid_589055 = validateParameter(valid_589055, JString, required = true,
                                 default = nil)
  if valid_589055 != nil:
    section.add "name", valid_589055
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
  var valid_589056 = query.getOrDefault("upload_protocol")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "upload_protocol", valid_589056
  var valid_589057 = query.getOrDefault("fields")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "fields", valid_589057
  var valid_589058 = query.getOrDefault("pageToken")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "pageToken", valid_589058
  var valid_589059 = query.getOrDefault("quotaUser")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "quotaUser", valid_589059
  var valid_589060 = query.getOrDefault("alt")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = newJString("json"))
  if valid_589060 != nil:
    section.add "alt", valid_589060
  var valid_589061 = query.getOrDefault("oauth_token")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "oauth_token", valid_589061
  var valid_589062 = query.getOrDefault("callback")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "callback", valid_589062
  var valid_589063 = query.getOrDefault("access_token")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "access_token", valid_589063
  var valid_589064 = query.getOrDefault("uploadType")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "uploadType", valid_589064
  var valid_589065 = query.getOrDefault("key")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "key", valid_589065
  var valid_589066 = query.getOrDefault("$.xgafv")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = newJString("1"))
  if valid_589066 != nil:
    section.add "$.xgafv", valid_589066
  var valid_589067 = query.getOrDefault("pageSize")
  valid_589067 = validateParameter(valid_589067, JInt, required = false, default = nil)
  if valid_589067 != nil:
    section.add "pageSize", valid_589067
  var valid_589068 = query.getOrDefault("prettyPrint")
  valid_589068 = validateParameter(valid_589068, JBool, required = false,
                                 default = newJBool(true))
  if valid_589068 != nil:
    section.add "prettyPrint", valid_589068
  var valid_589069 = query.getOrDefault("filter")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "filter", valid_589069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589070: Call_DialogflowProjectsLocationsOperationsList_589052;
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
  let valid = call_589070.validator(path, query, header, formData, body)
  let scheme = call_589070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589070.url(scheme.get, call_589070.host, call_589070.base,
                         call_589070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589070, url, valid)

proc call*(call_589071: Call_DialogflowProjectsLocationsOperationsList_589052;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## dialogflowProjectsLocationsOperationsList
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
  var path_589072 = newJObject()
  var query_589073 = newJObject()
  add(query_589073, "upload_protocol", newJString(uploadProtocol))
  add(query_589073, "fields", newJString(fields))
  add(query_589073, "pageToken", newJString(pageToken))
  add(query_589073, "quotaUser", newJString(quotaUser))
  add(path_589072, "name", newJString(name))
  add(query_589073, "alt", newJString(alt))
  add(query_589073, "oauth_token", newJString(oauthToken))
  add(query_589073, "callback", newJString(callback))
  add(query_589073, "access_token", newJString(accessToken))
  add(query_589073, "uploadType", newJString(uploadType))
  add(query_589073, "key", newJString(key))
  add(query_589073, "$.xgafv", newJString(Xgafv))
  add(query_589073, "pageSize", newJInt(pageSize))
  add(query_589073, "prettyPrint", newJBool(prettyPrint))
  add(query_589073, "filter", newJString(filter))
  result = call_589071.call(path_589072, query_589073, nil, nil, nil)

var dialogflowProjectsLocationsOperationsList* = Call_DialogflowProjectsLocationsOperationsList_589052(
    name: "dialogflowProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{name}/operations",
    validator: validate_DialogflowProjectsLocationsOperationsList_589053,
    base: "/", url: url_DialogflowProjectsLocationsOperationsList_589054,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsLocationsOperationsCancel_589074 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsLocationsOperationsCancel_589076(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsLocationsOperationsCancel_589075(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589077 = path.getOrDefault("name")
  valid_589077 = validateParameter(valid_589077, JString, required = true,
                                 default = nil)
  if valid_589077 != nil:
    section.add "name", valid_589077
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
  var valid_589078 = query.getOrDefault("upload_protocol")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "upload_protocol", valid_589078
  var valid_589079 = query.getOrDefault("fields")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "fields", valid_589079
  var valid_589080 = query.getOrDefault("quotaUser")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "quotaUser", valid_589080
  var valid_589081 = query.getOrDefault("alt")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = newJString("json"))
  if valid_589081 != nil:
    section.add "alt", valid_589081
  var valid_589082 = query.getOrDefault("oauth_token")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "oauth_token", valid_589082
  var valid_589083 = query.getOrDefault("callback")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "callback", valid_589083
  var valid_589084 = query.getOrDefault("access_token")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "access_token", valid_589084
  var valid_589085 = query.getOrDefault("uploadType")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "uploadType", valid_589085
  var valid_589086 = query.getOrDefault("key")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "key", valid_589086
  var valid_589087 = query.getOrDefault("$.xgafv")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("1"))
  if valid_589087 != nil:
    section.add "$.xgafv", valid_589087
  var valid_589088 = query.getOrDefault("prettyPrint")
  valid_589088 = validateParameter(valid_589088, JBool, required = false,
                                 default = newJBool(true))
  if valid_589088 != nil:
    section.add "prettyPrint", valid_589088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589089: Call_DialogflowProjectsLocationsOperationsCancel_589074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_589089.validator(path, query, header, formData, body)
  let scheme = call_589089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589089.url(scheme.get, call_589089.host, call_589089.base,
                         call_589089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589089, url, valid)

proc call*(call_589090: Call_DialogflowProjectsLocationsOperationsCancel_589074;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsLocationsOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  var path_589091 = newJObject()
  var query_589092 = newJObject()
  add(query_589092, "upload_protocol", newJString(uploadProtocol))
  add(query_589092, "fields", newJString(fields))
  add(query_589092, "quotaUser", newJString(quotaUser))
  add(path_589091, "name", newJString(name))
  add(query_589092, "alt", newJString(alt))
  add(query_589092, "oauth_token", newJString(oauthToken))
  add(query_589092, "callback", newJString(callback))
  add(query_589092, "access_token", newJString(accessToken))
  add(query_589092, "uploadType", newJString(uploadType))
  add(query_589092, "key", newJString(key))
  add(query_589092, "$.xgafv", newJString(Xgafv))
  add(query_589092, "prettyPrint", newJBool(prettyPrint))
  result = call_589090.call(path_589091, query_589092, nil, nil, nil)

var dialogflowProjectsLocationsOperationsCancel* = Call_DialogflowProjectsLocationsOperationsCancel_589074(
    name: "dialogflowProjectsLocationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{name}:cancel",
    validator: validate_DialogflowProjectsLocationsOperationsCancel_589075,
    base: "/", url: url_DialogflowProjectsLocationsOperationsCancel_589076,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgent_589112 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgent_589114(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgent_589113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates/updates the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project of this agent.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589115 = path.getOrDefault("parent")
  valid_589115 = validateParameter(valid_589115, JString, required = true,
                                 default = nil)
  if valid_589115 != nil:
    section.add "parent", valid_589115
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
  ##   updateMask: JString
  ##             : Optional. The mask to control which fields get updated.
  section = newJObject()
  var valid_589116 = query.getOrDefault("upload_protocol")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "upload_protocol", valid_589116
  var valid_589117 = query.getOrDefault("fields")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "fields", valid_589117
  var valid_589118 = query.getOrDefault("quotaUser")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "quotaUser", valid_589118
  var valid_589119 = query.getOrDefault("alt")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("json"))
  if valid_589119 != nil:
    section.add "alt", valid_589119
  var valid_589120 = query.getOrDefault("oauth_token")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "oauth_token", valid_589120
  var valid_589121 = query.getOrDefault("callback")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "callback", valid_589121
  var valid_589122 = query.getOrDefault("access_token")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "access_token", valid_589122
  var valid_589123 = query.getOrDefault("uploadType")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "uploadType", valid_589123
  var valid_589124 = query.getOrDefault("key")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "key", valid_589124
  var valid_589125 = query.getOrDefault("$.xgafv")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = newJString("1"))
  if valid_589125 != nil:
    section.add "$.xgafv", valid_589125
  var valid_589126 = query.getOrDefault("prettyPrint")
  valid_589126 = validateParameter(valid_589126, JBool, required = false,
                                 default = newJBool(true))
  if valid_589126 != nil:
    section.add "prettyPrint", valid_589126
  var valid_589127 = query.getOrDefault("updateMask")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "updateMask", valid_589127
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

proc call*(call_589129: Call_DialogflowProjectsAgent_589112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates/updates the specified agent.
  ## 
  let valid = call_589129.validator(path, query, header, formData, body)
  let scheme = call_589129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589129.url(scheme.get, call_589129.host, call_589129.base,
                         call_589129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589129, url, valid)

proc call*(call_589130: Call_DialogflowProjectsAgent_589112; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## dialogflowProjectsAgent
  ## Creates/updates the specified agent.
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
  ##   parent: string (required)
  ##         : Required. The project of this agent.
  ## Format: `projects/<Project ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Optional. The mask to control which fields get updated.
  var path_589131 = newJObject()
  var query_589132 = newJObject()
  var body_589133 = newJObject()
  add(query_589132, "upload_protocol", newJString(uploadProtocol))
  add(query_589132, "fields", newJString(fields))
  add(query_589132, "quotaUser", newJString(quotaUser))
  add(query_589132, "alt", newJString(alt))
  add(query_589132, "oauth_token", newJString(oauthToken))
  add(query_589132, "callback", newJString(callback))
  add(query_589132, "access_token", newJString(accessToken))
  add(query_589132, "uploadType", newJString(uploadType))
  add(path_589131, "parent", newJString(parent))
  add(query_589132, "key", newJString(key))
  add(query_589132, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589133 = body
  add(query_589132, "prettyPrint", newJBool(prettyPrint))
  add(query_589132, "updateMask", newJString(updateMask))
  result = call_589130.call(path_589131, query_589132, nil, nil, body_589133)

var dialogflowProjectsAgent* = Call_DialogflowProjectsAgent_589112(
    name: "dialogflowProjectsAgent", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent",
    validator: validate_DialogflowProjectsAgent_589113, base: "/",
    url: url_DialogflowProjectsAgent_589114, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsGetAgent_589093 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsGetAgent_589095(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsGetAgent_589094(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project that the agent to fetch is associated with.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589096 = path.getOrDefault("parent")
  valid_589096 = validateParameter(valid_589096, JString, required = true,
                                 default = nil)
  if valid_589096 != nil:
    section.add "parent", valid_589096
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
  var valid_589097 = query.getOrDefault("upload_protocol")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "upload_protocol", valid_589097
  var valid_589098 = query.getOrDefault("fields")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "fields", valid_589098
  var valid_589099 = query.getOrDefault("quotaUser")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "quotaUser", valid_589099
  var valid_589100 = query.getOrDefault("alt")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = newJString("json"))
  if valid_589100 != nil:
    section.add "alt", valid_589100
  var valid_589101 = query.getOrDefault("oauth_token")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "oauth_token", valid_589101
  var valid_589102 = query.getOrDefault("callback")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "callback", valid_589102
  var valid_589103 = query.getOrDefault("access_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "access_token", valid_589103
  var valid_589104 = query.getOrDefault("uploadType")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "uploadType", valid_589104
  var valid_589105 = query.getOrDefault("key")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "key", valid_589105
  var valid_589106 = query.getOrDefault("$.xgafv")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = newJString("1"))
  if valid_589106 != nil:
    section.add "$.xgafv", valid_589106
  var valid_589107 = query.getOrDefault("prettyPrint")
  valid_589107 = validateParameter(valid_589107, JBool, required = false,
                                 default = newJBool(true))
  if valid_589107 != nil:
    section.add "prettyPrint", valid_589107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589108: Call_DialogflowProjectsGetAgent_589093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified agent.
  ## 
  let valid = call_589108.validator(path, query, header, formData, body)
  let scheme = call_589108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589108.url(scheme.get, call_589108.host, call_589108.base,
                         call_589108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589108, url, valid)

proc call*(call_589109: Call_DialogflowProjectsGetAgent_589093; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsGetAgent
  ## Retrieves the specified agent.
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
  ##   parent: string (required)
  ##         : Required. The project that the agent to fetch is associated with.
  ## Format: `projects/<Project ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589110 = newJObject()
  var query_589111 = newJObject()
  add(query_589111, "upload_protocol", newJString(uploadProtocol))
  add(query_589111, "fields", newJString(fields))
  add(query_589111, "quotaUser", newJString(quotaUser))
  add(query_589111, "alt", newJString(alt))
  add(query_589111, "oauth_token", newJString(oauthToken))
  add(query_589111, "callback", newJString(callback))
  add(query_589111, "access_token", newJString(accessToken))
  add(query_589111, "uploadType", newJString(uploadType))
  add(path_589110, "parent", newJString(parent))
  add(query_589111, "key", newJString(key))
  add(query_589111, "$.xgafv", newJString(Xgafv))
  add(query_589111, "prettyPrint", newJBool(prettyPrint))
  result = call_589109.call(path_589110, query_589111, nil, nil, nil)

var dialogflowProjectsGetAgent* = Call_DialogflowProjectsGetAgent_589093(
    name: "dialogflowProjectsGetAgent", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent",
    validator: validate_DialogflowProjectsGetAgent_589094, base: "/",
    url: url_DialogflowProjectsGetAgent_589095, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsDeleteAgent_589134 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsDeleteAgent_589136(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsDeleteAgent_589135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project that the agent to delete is associated with.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589137 = path.getOrDefault("parent")
  valid_589137 = validateParameter(valid_589137, JString, required = true,
                                 default = nil)
  if valid_589137 != nil:
    section.add "parent", valid_589137
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
  var valid_589138 = query.getOrDefault("upload_protocol")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "upload_protocol", valid_589138
  var valid_589139 = query.getOrDefault("fields")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "fields", valid_589139
  var valid_589140 = query.getOrDefault("quotaUser")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "quotaUser", valid_589140
  var valid_589141 = query.getOrDefault("alt")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = newJString("json"))
  if valid_589141 != nil:
    section.add "alt", valid_589141
  var valid_589142 = query.getOrDefault("oauth_token")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "oauth_token", valid_589142
  var valid_589143 = query.getOrDefault("callback")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "callback", valid_589143
  var valid_589144 = query.getOrDefault("access_token")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "access_token", valid_589144
  var valid_589145 = query.getOrDefault("uploadType")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "uploadType", valid_589145
  var valid_589146 = query.getOrDefault("key")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "key", valid_589146
  var valid_589147 = query.getOrDefault("$.xgafv")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = newJString("1"))
  if valid_589147 != nil:
    section.add "$.xgafv", valid_589147
  var valid_589148 = query.getOrDefault("prettyPrint")
  valid_589148 = validateParameter(valid_589148, JBool, required = false,
                                 default = newJBool(true))
  if valid_589148 != nil:
    section.add "prettyPrint", valid_589148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589149: Call_DialogflowProjectsDeleteAgent_589134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified agent.
  ## 
  let valid = call_589149.validator(path, query, header, formData, body)
  let scheme = call_589149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589149.url(scheme.get, call_589149.host, call_589149.base,
                         call_589149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589149, url, valid)

proc call*(call_589150: Call_DialogflowProjectsDeleteAgent_589134; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsDeleteAgent
  ## Deletes the specified agent.
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
  ##   parent: string (required)
  ##         : Required. The project that the agent to delete is associated with.
  ## Format: `projects/<Project ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589151 = newJObject()
  var query_589152 = newJObject()
  add(query_589152, "upload_protocol", newJString(uploadProtocol))
  add(query_589152, "fields", newJString(fields))
  add(query_589152, "quotaUser", newJString(quotaUser))
  add(query_589152, "alt", newJString(alt))
  add(query_589152, "oauth_token", newJString(oauthToken))
  add(query_589152, "callback", newJString(callback))
  add(query_589152, "access_token", newJString(accessToken))
  add(query_589152, "uploadType", newJString(uploadType))
  add(path_589151, "parent", newJString(parent))
  add(query_589152, "key", newJString(key))
  add(query_589152, "$.xgafv", newJString(Xgafv))
  add(query_589152, "prettyPrint", newJBool(prettyPrint))
  result = call_589150.call(path_589151, query_589152, nil, nil, nil)

var dialogflowProjectsDeleteAgent* = Call_DialogflowProjectsDeleteAgent_589134(
    name: "dialogflowProjectsDeleteAgent", meth: HttpMethod.HttpDelete,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent",
    validator: validate_DialogflowProjectsDeleteAgent_589135, base: "/",
    url: url_DialogflowProjectsDeleteAgent_589136, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentExport_589153 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentExport_589155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent:export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentExport_589154(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the specified agent to a ZIP file.
  ## 
  ## Operation <response: ExportAgentResponse>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project that the agent to export is associated with.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589156 = path.getOrDefault("parent")
  valid_589156 = validateParameter(valid_589156, JString, required = true,
                                 default = nil)
  if valid_589156 != nil:
    section.add "parent", valid_589156
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
  var valid_589157 = query.getOrDefault("upload_protocol")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "upload_protocol", valid_589157
  var valid_589158 = query.getOrDefault("fields")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "fields", valid_589158
  var valid_589159 = query.getOrDefault("quotaUser")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "quotaUser", valid_589159
  var valid_589160 = query.getOrDefault("alt")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = newJString("json"))
  if valid_589160 != nil:
    section.add "alt", valid_589160
  var valid_589161 = query.getOrDefault("oauth_token")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "oauth_token", valid_589161
  var valid_589162 = query.getOrDefault("callback")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "callback", valid_589162
  var valid_589163 = query.getOrDefault("access_token")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "access_token", valid_589163
  var valid_589164 = query.getOrDefault("uploadType")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "uploadType", valid_589164
  var valid_589165 = query.getOrDefault("key")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "key", valid_589165
  var valid_589166 = query.getOrDefault("$.xgafv")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = newJString("1"))
  if valid_589166 != nil:
    section.add "$.xgafv", valid_589166
  var valid_589167 = query.getOrDefault("prettyPrint")
  valid_589167 = validateParameter(valid_589167, JBool, required = false,
                                 default = newJBool(true))
  if valid_589167 != nil:
    section.add "prettyPrint", valid_589167
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

proc call*(call_589169: Call_DialogflowProjectsAgentExport_589153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the specified agent to a ZIP file.
  ## 
  ## Operation <response: ExportAgentResponse>
  ## 
  let valid = call_589169.validator(path, query, header, formData, body)
  let scheme = call_589169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589169.url(scheme.get, call_589169.host, call_589169.base,
                         call_589169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589169, url, valid)

proc call*(call_589170: Call_DialogflowProjectsAgentExport_589153; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentExport
  ## Exports the specified agent to a ZIP file.
  ## 
  ## Operation <response: ExportAgentResponse>
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
  ##   parent: string (required)
  ##         : Required. The project that the agent to export is associated with.
  ## Format: `projects/<Project ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589171 = newJObject()
  var query_589172 = newJObject()
  var body_589173 = newJObject()
  add(query_589172, "upload_protocol", newJString(uploadProtocol))
  add(query_589172, "fields", newJString(fields))
  add(query_589172, "quotaUser", newJString(quotaUser))
  add(query_589172, "alt", newJString(alt))
  add(query_589172, "oauth_token", newJString(oauthToken))
  add(query_589172, "callback", newJString(callback))
  add(query_589172, "access_token", newJString(accessToken))
  add(query_589172, "uploadType", newJString(uploadType))
  add(path_589171, "parent", newJString(parent))
  add(query_589172, "key", newJString(key))
  add(query_589172, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589173 = body
  add(query_589172, "prettyPrint", newJBool(prettyPrint))
  result = call_589170.call(path_589171, query_589172, nil, nil, body_589173)

var dialogflowProjectsAgentExport* = Call_DialogflowProjectsAgentExport_589153(
    name: "dialogflowProjectsAgentExport", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent:export",
    validator: validate_DialogflowProjectsAgentExport_589154, base: "/",
    url: url_DialogflowProjectsAgentExport_589155, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentImport_589174 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentImport_589176(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent:import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentImport_589175(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports the specified agent from a ZIP file.
  ## 
  ## Uploads new intents and entity types without deleting the existing ones.
  ## Intents and entity types with the same name are replaced with the new
  ## versions from ImportAgentRequest.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project that the agent to import is associated with.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589177 = path.getOrDefault("parent")
  valid_589177 = validateParameter(valid_589177, JString, required = true,
                                 default = nil)
  if valid_589177 != nil:
    section.add "parent", valid_589177
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
  var valid_589178 = query.getOrDefault("upload_protocol")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "upload_protocol", valid_589178
  var valid_589179 = query.getOrDefault("fields")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "fields", valid_589179
  var valid_589180 = query.getOrDefault("quotaUser")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "quotaUser", valid_589180
  var valid_589181 = query.getOrDefault("alt")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = newJString("json"))
  if valid_589181 != nil:
    section.add "alt", valid_589181
  var valid_589182 = query.getOrDefault("oauth_token")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "oauth_token", valid_589182
  var valid_589183 = query.getOrDefault("callback")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "callback", valid_589183
  var valid_589184 = query.getOrDefault("access_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "access_token", valid_589184
  var valid_589185 = query.getOrDefault("uploadType")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "uploadType", valid_589185
  var valid_589186 = query.getOrDefault("key")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "key", valid_589186
  var valid_589187 = query.getOrDefault("$.xgafv")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = newJString("1"))
  if valid_589187 != nil:
    section.add "$.xgafv", valid_589187
  var valid_589188 = query.getOrDefault("prettyPrint")
  valid_589188 = validateParameter(valid_589188, JBool, required = false,
                                 default = newJBool(true))
  if valid_589188 != nil:
    section.add "prettyPrint", valid_589188
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

proc call*(call_589190: Call_DialogflowProjectsAgentImport_589174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports the specified agent from a ZIP file.
  ## 
  ## Uploads new intents and entity types without deleting the existing ones.
  ## Intents and entity types with the same name are replaced with the new
  ## versions from ImportAgentRequest.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_589190.validator(path, query, header, formData, body)
  let scheme = call_589190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589190.url(scheme.get, call_589190.host, call_589190.base,
                         call_589190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589190, url, valid)

proc call*(call_589191: Call_DialogflowProjectsAgentImport_589174; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentImport
  ## Imports the specified agent from a ZIP file.
  ## 
  ## Uploads new intents and entity types without deleting the existing ones.
  ## Intents and entity types with the same name are replaced with the new
  ## versions from ImportAgentRequest.
  ## 
  ## Operation <response: google.protobuf.Empty>
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
  ##   parent: string (required)
  ##         : Required. The project that the agent to import is associated with.
  ## Format: `projects/<Project ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589192 = newJObject()
  var query_589193 = newJObject()
  var body_589194 = newJObject()
  add(query_589193, "upload_protocol", newJString(uploadProtocol))
  add(query_589193, "fields", newJString(fields))
  add(query_589193, "quotaUser", newJString(quotaUser))
  add(query_589193, "alt", newJString(alt))
  add(query_589193, "oauth_token", newJString(oauthToken))
  add(query_589193, "callback", newJString(callback))
  add(query_589193, "access_token", newJString(accessToken))
  add(query_589193, "uploadType", newJString(uploadType))
  add(path_589192, "parent", newJString(parent))
  add(query_589193, "key", newJString(key))
  add(query_589193, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589194 = body
  add(query_589193, "prettyPrint", newJBool(prettyPrint))
  result = call_589191.call(path_589192, query_589193, nil, nil, body_589194)

var dialogflowProjectsAgentImport* = Call_DialogflowProjectsAgentImport_589174(
    name: "dialogflowProjectsAgentImport", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent:import",
    validator: validate_DialogflowProjectsAgentImport_589175, base: "/",
    url: url_DialogflowProjectsAgentImport_589176, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentRestore_589195 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentRestore_589197(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent:restore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentRestore_589196(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores the specified agent from a ZIP file.
  ## 
  ## Replaces the current agent version with a new one. All the intents and
  ## entity types in the older version are deleted.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project that the agent to restore is associated with.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589198 = path.getOrDefault("parent")
  valid_589198 = validateParameter(valid_589198, JString, required = true,
                                 default = nil)
  if valid_589198 != nil:
    section.add "parent", valid_589198
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
  var valid_589199 = query.getOrDefault("upload_protocol")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "upload_protocol", valid_589199
  var valid_589200 = query.getOrDefault("fields")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "fields", valid_589200
  var valid_589201 = query.getOrDefault("quotaUser")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "quotaUser", valid_589201
  var valid_589202 = query.getOrDefault("alt")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("json"))
  if valid_589202 != nil:
    section.add "alt", valid_589202
  var valid_589203 = query.getOrDefault("oauth_token")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "oauth_token", valid_589203
  var valid_589204 = query.getOrDefault("callback")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "callback", valid_589204
  var valid_589205 = query.getOrDefault("access_token")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "access_token", valid_589205
  var valid_589206 = query.getOrDefault("uploadType")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "uploadType", valid_589206
  var valid_589207 = query.getOrDefault("key")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "key", valid_589207
  var valid_589208 = query.getOrDefault("$.xgafv")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = newJString("1"))
  if valid_589208 != nil:
    section.add "$.xgafv", valid_589208
  var valid_589209 = query.getOrDefault("prettyPrint")
  valid_589209 = validateParameter(valid_589209, JBool, required = false,
                                 default = newJBool(true))
  if valid_589209 != nil:
    section.add "prettyPrint", valid_589209
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

proc call*(call_589211: Call_DialogflowProjectsAgentRestore_589195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the specified agent from a ZIP file.
  ## 
  ## Replaces the current agent version with a new one. All the intents and
  ## entity types in the older version are deleted.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_589211.validator(path, query, header, formData, body)
  let scheme = call_589211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589211.url(scheme.get, call_589211.host, call_589211.base,
                         call_589211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589211, url, valid)

proc call*(call_589212: Call_DialogflowProjectsAgentRestore_589195; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentRestore
  ## Restores the specified agent from a ZIP file.
  ## 
  ## Replaces the current agent version with a new one. All the intents and
  ## entity types in the older version are deleted.
  ## 
  ## Operation <response: google.protobuf.Empty>
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
  ##   parent: string (required)
  ##         : Required. The project that the agent to restore is associated with.
  ## Format: `projects/<Project ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589213 = newJObject()
  var query_589214 = newJObject()
  var body_589215 = newJObject()
  add(query_589214, "upload_protocol", newJString(uploadProtocol))
  add(query_589214, "fields", newJString(fields))
  add(query_589214, "quotaUser", newJString(quotaUser))
  add(query_589214, "alt", newJString(alt))
  add(query_589214, "oauth_token", newJString(oauthToken))
  add(query_589214, "callback", newJString(callback))
  add(query_589214, "access_token", newJString(accessToken))
  add(query_589214, "uploadType", newJString(uploadType))
  add(path_589213, "parent", newJString(parent))
  add(query_589214, "key", newJString(key))
  add(query_589214, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589215 = body
  add(query_589214, "prettyPrint", newJBool(prettyPrint))
  result = call_589212.call(path_589213, query_589214, nil, nil, body_589215)

var dialogflowProjectsAgentRestore* = Call_DialogflowProjectsAgentRestore_589195(
    name: "dialogflowProjectsAgentRestore", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent:restore",
    validator: validate_DialogflowProjectsAgentRestore_589196, base: "/",
    url: url_DialogflowProjectsAgentRestore_589197, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentSearch_589216 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentSearch_589218(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentSearch_589217(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of agents.
  ## 
  ## Since there is at most one conversational agent per project, this method is
  ## useful primarily for listing all agents across projects the caller has
  ## access to. One can achieve that with a wildcard project collection id "-".
  ## Refer to [List
  ## Sub-Collections](https://cloud.google.com/apis/design/design_patterns#list_sub-collections).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project to list agents from.
  ## Format: `projects/<Project ID or '-'>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589219 = path.getOrDefault("parent")
  valid_589219 = validateParameter(valid_589219, JString, required = true,
                                 default = nil)
  if valid_589219 != nil:
    section.add "parent", valid_589219
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous list request.
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
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589220 = query.getOrDefault("upload_protocol")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "upload_protocol", valid_589220
  var valid_589221 = query.getOrDefault("fields")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "fields", valid_589221
  var valid_589222 = query.getOrDefault("pageToken")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "pageToken", valid_589222
  var valid_589223 = query.getOrDefault("quotaUser")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "quotaUser", valid_589223
  var valid_589224 = query.getOrDefault("alt")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = newJString("json"))
  if valid_589224 != nil:
    section.add "alt", valid_589224
  var valid_589225 = query.getOrDefault("oauth_token")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "oauth_token", valid_589225
  var valid_589226 = query.getOrDefault("callback")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "callback", valid_589226
  var valid_589227 = query.getOrDefault("access_token")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "access_token", valid_589227
  var valid_589228 = query.getOrDefault("uploadType")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "uploadType", valid_589228
  var valid_589229 = query.getOrDefault("key")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "key", valid_589229
  var valid_589230 = query.getOrDefault("$.xgafv")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = newJString("1"))
  if valid_589230 != nil:
    section.add "$.xgafv", valid_589230
  var valid_589231 = query.getOrDefault("pageSize")
  valid_589231 = validateParameter(valid_589231, JInt, required = false, default = nil)
  if valid_589231 != nil:
    section.add "pageSize", valid_589231
  var valid_589232 = query.getOrDefault("prettyPrint")
  valid_589232 = validateParameter(valid_589232, JBool, required = false,
                                 default = newJBool(true))
  if valid_589232 != nil:
    section.add "prettyPrint", valid_589232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589233: Call_DialogflowProjectsAgentSearch_589216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of agents.
  ## 
  ## Since there is at most one conversational agent per project, this method is
  ## useful primarily for listing all agents across projects the caller has
  ## access to. One can achieve that with a wildcard project collection id "-".
  ## Refer to [List
  ## Sub-Collections](https://cloud.google.com/apis/design/design_patterns#list_sub-collections).
  ## 
  let valid = call_589233.validator(path, query, header, formData, body)
  let scheme = call_589233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589233.url(scheme.get, call_589233.host, call_589233.base,
                         call_589233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589233, url, valid)

proc call*(call_589234: Call_DialogflowProjectsAgentSearch_589216; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentSearch
  ## Returns the list of agents.
  ## 
  ## Since there is at most one conversational agent per project, this method is
  ## useful primarily for listing all agents across projects the caller has
  ## access to. One can achieve that with a wildcard project collection id "-".
  ## Refer to [List
  ## Sub-Collections](https://cloud.google.com/apis/design/design_patterns#list_sub-collections).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous list request.
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
  ##   parent: string (required)
  ##         : Required. The project to list agents from.
  ## Format: `projects/<Project ID or '-'>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589235 = newJObject()
  var query_589236 = newJObject()
  add(query_589236, "upload_protocol", newJString(uploadProtocol))
  add(query_589236, "fields", newJString(fields))
  add(query_589236, "pageToken", newJString(pageToken))
  add(query_589236, "quotaUser", newJString(quotaUser))
  add(query_589236, "alt", newJString(alt))
  add(query_589236, "oauth_token", newJString(oauthToken))
  add(query_589236, "callback", newJString(callback))
  add(query_589236, "access_token", newJString(accessToken))
  add(query_589236, "uploadType", newJString(uploadType))
  add(path_589235, "parent", newJString(parent))
  add(query_589236, "key", newJString(key))
  add(query_589236, "$.xgafv", newJString(Xgafv))
  add(query_589236, "pageSize", newJInt(pageSize))
  add(query_589236, "prettyPrint", newJBool(prettyPrint))
  result = call_589234.call(path_589235, query_589236, nil, nil, nil)

var dialogflowProjectsAgentSearch* = Call_DialogflowProjectsAgentSearch_589216(
    name: "dialogflowProjectsAgentSearch", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent:search",
    validator: validate_DialogflowProjectsAgentSearch_589217, base: "/",
    url: url_DialogflowProjectsAgentSearch_589218, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentTrain_589237 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentTrain_589239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent:train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentTrain_589238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Trains the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project that the agent to train is associated with.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589240 = path.getOrDefault("parent")
  valid_589240 = validateParameter(valid_589240, JString, required = true,
                                 default = nil)
  if valid_589240 != nil:
    section.add "parent", valid_589240
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
  var valid_589241 = query.getOrDefault("upload_protocol")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "upload_protocol", valid_589241
  var valid_589242 = query.getOrDefault("fields")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "fields", valid_589242
  var valid_589243 = query.getOrDefault("quotaUser")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "quotaUser", valid_589243
  var valid_589244 = query.getOrDefault("alt")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = newJString("json"))
  if valid_589244 != nil:
    section.add "alt", valid_589244
  var valid_589245 = query.getOrDefault("oauth_token")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "oauth_token", valid_589245
  var valid_589246 = query.getOrDefault("callback")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "callback", valid_589246
  var valid_589247 = query.getOrDefault("access_token")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "access_token", valid_589247
  var valid_589248 = query.getOrDefault("uploadType")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "uploadType", valid_589248
  var valid_589249 = query.getOrDefault("key")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "key", valid_589249
  var valid_589250 = query.getOrDefault("$.xgafv")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = newJString("1"))
  if valid_589250 != nil:
    section.add "$.xgafv", valid_589250
  var valid_589251 = query.getOrDefault("prettyPrint")
  valid_589251 = validateParameter(valid_589251, JBool, required = false,
                                 default = newJBool(true))
  if valid_589251 != nil:
    section.add "prettyPrint", valid_589251
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

proc call*(call_589253: Call_DialogflowProjectsAgentTrain_589237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Trains the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_589253.validator(path, query, header, formData, body)
  let scheme = call_589253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589253.url(scheme.get, call_589253.host, call_589253.base,
                         call_589253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589253, url, valid)

proc call*(call_589254: Call_DialogflowProjectsAgentTrain_589237; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentTrain
  ## Trains the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
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
  ##   parent: string (required)
  ##         : Required. The project that the agent to train is associated with.
  ## Format: `projects/<Project ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589255 = newJObject()
  var query_589256 = newJObject()
  var body_589257 = newJObject()
  add(query_589256, "upload_protocol", newJString(uploadProtocol))
  add(query_589256, "fields", newJString(fields))
  add(query_589256, "quotaUser", newJString(quotaUser))
  add(query_589256, "alt", newJString(alt))
  add(query_589256, "oauth_token", newJString(oauthToken))
  add(query_589256, "callback", newJString(callback))
  add(query_589256, "access_token", newJString(accessToken))
  add(query_589256, "uploadType", newJString(uploadType))
  add(path_589255, "parent", newJString(parent))
  add(query_589256, "key", newJString(key))
  add(query_589256, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589257 = body
  add(query_589256, "prettyPrint", newJBool(prettyPrint))
  result = call_589254.call(path_589255, query_589256, nil, nil, body_589257)

var dialogflowProjectsAgentTrain* = Call_DialogflowProjectsAgentTrain_589237(
    name: "dialogflowProjectsAgentTrain", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent:train",
    validator: validate_DialogflowProjectsAgentTrain_589238, base: "/",
    url: url_DialogflowProjectsAgentTrain_589239, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentSessionsContextsCreate_589279 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentSessionsContextsCreate_589281(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/contexts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentSessionsContextsCreate_589280(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a context.
  ## 
  ## If the specified context already exists, overrides the context.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The session to create a context for.
  ## Format: `projects/<Project ID>/agent/sessions/<Session ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589282 = path.getOrDefault("parent")
  valid_589282 = validateParameter(valid_589282, JString, required = true,
                                 default = nil)
  if valid_589282 != nil:
    section.add "parent", valid_589282
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
  var valid_589283 = query.getOrDefault("upload_protocol")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "upload_protocol", valid_589283
  var valid_589284 = query.getOrDefault("fields")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "fields", valid_589284
  var valid_589285 = query.getOrDefault("quotaUser")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "quotaUser", valid_589285
  var valid_589286 = query.getOrDefault("alt")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = newJString("json"))
  if valid_589286 != nil:
    section.add "alt", valid_589286
  var valid_589287 = query.getOrDefault("oauth_token")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "oauth_token", valid_589287
  var valid_589288 = query.getOrDefault("callback")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "callback", valid_589288
  var valid_589289 = query.getOrDefault("access_token")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "access_token", valid_589289
  var valid_589290 = query.getOrDefault("uploadType")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "uploadType", valid_589290
  var valid_589291 = query.getOrDefault("key")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "key", valid_589291
  var valid_589292 = query.getOrDefault("$.xgafv")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = newJString("1"))
  if valid_589292 != nil:
    section.add "$.xgafv", valid_589292
  var valid_589293 = query.getOrDefault("prettyPrint")
  valid_589293 = validateParameter(valid_589293, JBool, required = false,
                                 default = newJBool(true))
  if valid_589293 != nil:
    section.add "prettyPrint", valid_589293
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

proc call*(call_589295: Call_DialogflowProjectsAgentSessionsContextsCreate_589279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a context.
  ## 
  ## If the specified context already exists, overrides the context.
  ## 
  let valid = call_589295.validator(path, query, header, formData, body)
  let scheme = call_589295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589295.url(scheme.get, call_589295.host, call_589295.base,
                         call_589295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589295, url, valid)

proc call*(call_589296: Call_DialogflowProjectsAgentSessionsContextsCreate_589279;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentSessionsContextsCreate
  ## Creates a context.
  ## 
  ## If the specified context already exists, overrides the context.
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
  ##   parent: string (required)
  ##         : Required. The session to create a context for.
  ## Format: `projects/<Project ID>/agent/sessions/<Session ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589297 = newJObject()
  var query_589298 = newJObject()
  var body_589299 = newJObject()
  add(query_589298, "upload_protocol", newJString(uploadProtocol))
  add(query_589298, "fields", newJString(fields))
  add(query_589298, "quotaUser", newJString(quotaUser))
  add(query_589298, "alt", newJString(alt))
  add(query_589298, "oauth_token", newJString(oauthToken))
  add(query_589298, "callback", newJString(callback))
  add(query_589298, "access_token", newJString(accessToken))
  add(query_589298, "uploadType", newJString(uploadType))
  add(path_589297, "parent", newJString(parent))
  add(query_589298, "key", newJString(key))
  add(query_589298, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589299 = body
  add(query_589298, "prettyPrint", newJBool(prettyPrint))
  result = call_589296.call(path_589297, query_589298, nil, nil, body_589299)

var dialogflowProjectsAgentSessionsContextsCreate* = Call_DialogflowProjectsAgentSessionsContextsCreate_589279(
    name: "dialogflowProjectsAgentSessionsContextsCreate",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/contexts",
    validator: validate_DialogflowProjectsAgentSessionsContextsCreate_589280,
    base: "/", url: url_DialogflowProjectsAgentSessionsContextsCreate_589281,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentSessionsContextsList_589258 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentSessionsContextsList_589260(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/contexts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentSessionsContextsList_589259(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of all contexts in the specified session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The session to list all contexts from.
  ## Format: `projects/<Project ID>/agent/sessions/<Session ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589261 = path.getOrDefault("parent")
  valid_589261 = validateParameter(valid_589261, JString, required = true,
                                 default = nil)
  if valid_589261 != nil:
    section.add "parent", valid_589261
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. The next_page_token value returned from a previous list request.
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
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589262 = query.getOrDefault("upload_protocol")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "upload_protocol", valid_589262
  var valid_589263 = query.getOrDefault("fields")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "fields", valid_589263
  var valid_589264 = query.getOrDefault("pageToken")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "pageToken", valid_589264
  var valid_589265 = query.getOrDefault("quotaUser")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "quotaUser", valid_589265
  var valid_589266 = query.getOrDefault("alt")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = newJString("json"))
  if valid_589266 != nil:
    section.add "alt", valid_589266
  var valid_589267 = query.getOrDefault("oauth_token")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "oauth_token", valid_589267
  var valid_589268 = query.getOrDefault("callback")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "callback", valid_589268
  var valid_589269 = query.getOrDefault("access_token")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "access_token", valid_589269
  var valid_589270 = query.getOrDefault("uploadType")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "uploadType", valid_589270
  var valid_589271 = query.getOrDefault("key")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "key", valid_589271
  var valid_589272 = query.getOrDefault("$.xgafv")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = newJString("1"))
  if valid_589272 != nil:
    section.add "$.xgafv", valid_589272
  var valid_589273 = query.getOrDefault("pageSize")
  valid_589273 = validateParameter(valid_589273, JInt, required = false, default = nil)
  if valid_589273 != nil:
    section.add "pageSize", valid_589273
  var valid_589274 = query.getOrDefault("prettyPrint")
  valid_589274 = validateParameter(valid_589274, JBool, required = false,
                                 default = newJBool(true))
  if valid_589274 != nil:
    section.add "prettyPrint", valid_589274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589275: Call_DialogflowProjectsAgentSessionsContextsList_589258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of all contexts in the specified session.
  ## 
  let valid = call_589275.validator(path, query, header, formData, body)
  let scheme = call_589275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589275.url(scheme.get, call_589275.host, call_589275.base,
                         call_589275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589275, url, valid)

proc call*(call_589276: Call_DialogflowProjectsAgentSessionsContextsList_589258;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentSessionsContextsList
  ## Returns the list of all contexts in the specified session.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. The next_page_token value returned from a previous list request.
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
  ##   parent: string (required)
  ##         : Required. The session to list all contexts from.
  ## Format: `projects/<Project ID>/agent/sessions/<Session ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589277 = newJObject()
  var query_589278 = newJObject()
  add(query_589278, "upload_protocol", newJString(uploadProtocol))
  add(query_589278, "fields", newJString(fields))
  add(query_589278, "pageToken", newJString(pageToken))
  add(query_589278, "quotaUser", newJString(quotaUser))
  add(query_589278, "alt", newJString(alt))
  add(query_589278, "oauth_token", newJString(oauthToken))
  add(query_589278, "callback", newJString(callback))
  add(query_589278, "access_token", newJString(accessToken))
  add(query_589278, "uploadType", newJString(uploadType))
  add(path_589277, "parent", newJString(parent))
  add(query_589278, "key", newJString(key))
  add(query_589278, "$.xgafv", newJString(Xgafv))
  add(query_589278, "pageSize", newJInt(pageSize))
  add(query_589278, "prettyPrint", newJBool(prettyPrint))
  result = call_589276.call(path_589277, query_589278, nil, nil, nil)

var dialogflowProjectsAgentSessionsContextsList* = Call_DialogflowProjectsAgentSessionsContextsList_589258(
    name: "dialogflowProjectsAgentSessionsContextsList", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/contexts",
    validator: validate_DialogflowProjectsAgentSessionsContextsList_589259,
    base: "/", url: url_DialogflowProjectsAgentSessionsContextsList_589260,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentSessionsDeleteContexts_589300 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentSessionsDeleteContexts_589302(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/contexts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentSessionsDeleteContexts_589301(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes all active contexts in the specified session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the session to delete all contexts from. Format:
  ## `projects/<Project ID>/agent/sessions/<Session ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589303 = path.getOrDefault("parent")
  valid_589303 = validateParameter(valid_589303, JString, required = true,
                                 default = nil)
  if valid_589303 != nil:
    section.add "parent", valid_589303
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
  var valid_589304 = query.getOrDefault("upload_protocol")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "upload_protocol", valid_589304
  var valid_589305 = query.getOrDefault("fields")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "fields", valid_589305
  var valid_589306 = query.getOrDefault("quotaUser")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "quotaUser", valid_589306
  var valid_589307 = query.getOrDefault("alt")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = newJString("json"))
  if valid_589307 != nil:
    section.add "alt", valid_589307
  var valid_589308 = query.getOrDefault("oauth_token")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "oauth_token", valid_589308
  var valid_589309 = query.getOrDefault("callback")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "callback", valid_589309
  var valid_589310 = query.getOrDefault("access_token")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "access_token", valid_589310
  var valid_589311 = query.getOrDefault("uploadType")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "uploadType", valid_589311
  var valid_589312 = query.getOrDefault("key")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "key", valid_589312
  var valid_589313 = query.getOrDefault("$.xgafv")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("1"))
  if valid_589313 != nil:
    section.add "$.xgafv", valid_589313
  var valid_589314 = query.getOrDefault("prettyPrint")
  valid_589314 = validateParameter(valid_589314, JBool, required = false,
                                 default = newJBool(true))
  if valid_589314 != nil:
    section.add "prettyPrint", valid_589314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589315: Call_DialogflowProjectsAgentSessionsDeleteContexts_589300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all active contexts in the specified session.
  ## 
  let valid = call_589315.validator(path, query, header, formData, body)
  let scheme = call_589315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589315.url(scheme.get, call_589315.host, call_589315.base,
                         call_589315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589315, url, valid)

proc call*(call_589316: Call_DialogflowProjectsAgentSessionsDeleteContexts_589300;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentSessionsDeleteContexts
  ## Deletes all active contexts in the specified session.
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
  ##   parent: string (required)
  ##         : Required. The name of the session to delete all contexts from. Format:
  ## `projects/<Project ID>/agent/sessions/<Session ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589317 = newJObject()
  var query_589318 = newJObject()
  add(query_589318, "upload_protocol", newJString(uploadProtocol))
  add(query_589318, "fields", newJString(fields))
  add(query_589318, "quotaUser", newJString(quotaUser))
  add(query_589318, "alt", newJString(alt))
  add(query_589318, "oauth_token", newJString(oauthToken))
  add(query_589318, "callback", newJString(callback))
  add(query_589318, "access_token", newJString(accessToken))
  add(query_589318, "uploadType", newJString(uploadType))
  add(path_589317, "parent", newJString(parent))
  add(query_589318, "key", newJString(key))
  add(query_589318, "$.xgafv", newJString(Xgafv))
  add(query_589318, "prettyPrint", newJBool(prettyPrint))
  result = call_589316.call(path_589317, query_589318, nil, nil, nil)

var dialogflowProjectsAgentSessionsDeleteContexts* = Call_DialogflowProjectsAgentSessionsDeleteContexts_589300(
    name: "dialogflowProjectsAgentSessionsDeleteContexts",
    meth: HttpMethod.HttpDelete, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/contexts",
    validator: validate_DialogflowProjectsAgentSessionsDeleteContexts_589301,
    base: "/", url: url_DialogflowProjectsAgentSessionsDeleteContexts_589302,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_589319 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_589321(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entities:batchCreate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_589320(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates multiple new entities in the specified entity type.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the entity type to create entities in. Format:
  ## `projects/<Project ID>/agent/entityTypes/<Entity Type ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589322 = path.getOrDefault("parent")
  valid_589322 = validateParameter(valid_589322, JString, required = true,
                                 default = nil)
  if valid_589322 != nil:
    section.add "parent", valid_589322
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
  var valid_589323 = query.getOrDefault("upload_protocol")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "upload_protocol", valid_589323
  var valid_589324 = query.getOrDefault("fields")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "fields", valid_589324
  var valid_589325 = query.getOrDefault("quotaUser")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "quotaUser", valid_589325
  var valid_589326 = query.getOrDefault("alt")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = newJString("json"))
  if valid_589326 != nil:
    section.add "alt", valid_589326
  var valid_589327 = query.getOrDefault("oauth_token")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "oauth_token", valid_589327
  var valid_589328 = query.getOrDefault("callback")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "callback", valid_589328
  var valid_589329 = query.getOrDefault("access_token")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "access_token", valid_589329
  var valid_589330 = query.getOrDefault("uploadType")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "uploadType", valid_589330
  var valid_589331 = query.getOrDefault("key")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "key", valid_589331
  var valid_589332 = query.getOrDefault("$.xgafv")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = newJString("1"))
  if valid_589332 != nil:
    section.add "$.xgafv", valid_589332
  var valid_589333 = query.getOrDefault("prettyPrint")
  valid_589333 = validateParameter(valid_589333, JBool, required = false,
                                 default = newJBool(true))
  if valid_589333 != nil:
    section.add "prettyPrint", valid_589333
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

proc call*(call_589335: Call_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_589319;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates multiple new entities in the specified entity type.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_589335.validator(path, query, header, formData, body)
  let scheme = call_589335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589335.url(scheme.get, call_589335.host, call_589335.base,
                         call_589335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589335, url, valid)

proc call*(call_589336: Call_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_589319;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentEntityTypesEntitiesBatchCreate
  ## Creates multiple new entities in the specified entity type.
  ## 
  ## Operation <response: google.protobuf.Empty>
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
  ##   parent: string (required)
  ##         : Required. The name of the entity type to create entities in. Format:
  ## `projects/<Project ID>/agent/entityTypes/<Entity Type ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589337 = newJObject()
  var query_589338 = newJObject()
  var body_589339 = newJObject()
  add(query_589338, "upload_protocol", newJString(uploadProtocol))
  add(query_589338, "fields", newJString(fields))
  add(query_589338, "quotaUser", newJString(quotaUser))
  add(query_589338, "alt", newJString(alt))
  add(query_589338, "oauth_token", newJString(oauthToken))
  add(query_589338, "callback", newJString(callback))
  add(query_589338, "access_token", newJString(accessToken))
  add(query_589338, "uploadType", newJString(uploadType))
  add(path_589337, "parent", newJString(parent))
  add(query_589338, "key", newJString(key))
  add(query_589338, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589339 = body
  add(query_589338, "prettyPrint", newJBool(prettyPrint))
  result = call_589336.call(path_589337, query_589338, nil, nil, body_589339)

var dialogflowProjectsAgentEntityTypesEntitiesBatchCreate* = Call_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_589319(
    name: "dialogflowProjectsAgentEntityTypesEntitiesBatchCreate",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/entities:batchCreate",
    validator: validate_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_589320,
    base: "/", url: url_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_589321,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_589340 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_589342(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entities:batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_589341(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes entities in the specified entity type.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the entity type to delete entries for. Format:
  ## `projects/<Project ID>/agent/entityTypes/<Entity Type ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589343 = path.getOrDefault("parent")
  valid_589343 = validateParameter(valid_589343, JString, required = true,
                                 default = nil)
  if valid_589343 != nil:
    section.add "parent", valid_589343
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
  var valid_589344 = query.getOrDefault("upload_protocol")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "upload_protocol", valid_589344
  var valid_589345 = query.getOrDefault("fields")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "fields", valid_589345
  var valid_589346 = query.getOrDefault("quotaUser")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "quotaUser", valid_589346
  var valid_589347 = query.getOrDefault("alt")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = newJString("json"))
  if valid_589347 != nil:
    section.add "alt", valid_589347
  var valid_589348 = query.getOrDefault("oauth_token")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "oauth_token", valid_589348
  var valid_589349 = query.getOrDefault("callback")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "callback", valid_589349
  var valid_589350 = query.getOrDefault("access_token")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "access_token", valid_589350
  var valid_589351 = query.getOrDefault("uploadType")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "uploadType", valid_589351
  var valid_589352 = query.getOrDefault("key")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "key", valid_589352
  var valid_589353 = query.getOrDefault("$.xgafv")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = newJString("1"))
  if valid_589353 != nil:
    section.add "$.xgafv", valid_589353
  var valid_589354 = query.getOrDefault("prettyPrint")
  valid_589354 = validateParameter(valid_589354, JBool, required = false,
                                 default = newJBool(true))
  if valid_589354 != nil:
    section.add "prettyPrint", valid_589354
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

proc call*(call_589356: Call_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_589340;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes entities in the specified entity type.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_589356.validator(path, query, header, formData, body)
  let scheme = call_589356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589356.url(scheme.get, call_589356.host, call_589356.base,
                         call_589356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589356, url, valid)

proc call*(call_589357: Call_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_589340;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentEntityTypesEntitiesBatchDelete
  ## Deletes entities in the specified entity type.
  ## 
  ## Operation <response: google.protobuf.Empty>
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
  ##   parent: string (required)
  ##         : Required. The name of the entity type to delete entries for. Format:
  ## `projects/<Project ID>/agent/entityTypes/<Entity Type ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589358 = newJObject()
  var query_589359 = newJObject()
  var body_589360 = newJObject()
  add(query_589359, "upload_protocol", newJString(uploadProtocol))
  add(query_589359, "fields", newJString(fields))
  add(query_589359, "quotaUser", newJString(quotaUser))
  add(query_589359, "alt", newJString(alt))
  add(query_589359, "oauth_token", newJString(oauthToken))
  add(query_589359, "callback", newJString(callback))
  add(query_589359, "access_token", newJString(accessToken))
  add(query_589359, "uploadType", newJString(uploadType))
  add(path_589358, "parent", newJString(parent))
  add(query_589359, "key", newJString(key))
  add(query_589359, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589360 = body
  add(query_589359, "prettyPrint", newJBool(prettyPrint))
  result = call_589357.call(path_589358, query_589359, nil, nil, body_589360)

var dialogflowProjectsAgentEntityTypesEntitiesBatchDelete* = Call_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_589340(
    name: "dialogflowProjectsAgentEntityTypesEntitiesBatchDelete",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/entities:batchDelete",
    validator: validate_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_589341,
    base: "/", url: url_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_589342,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_589361 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_589363(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entities:batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_589362(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates or creates multiple entities in the specified entity type. This
  ## method does not affect entities in the entity type that aren't explicitly
  ## specified in the request.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the entity type to update or create entities in.
  ## Format: `projects/<Project ID>/agent/entityTypes/<Entity Type ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589364 = path.getOrDefault("parent")
  valid_589364 = validateParameter(valid_589364, JString, required = true,
                                 default = nil)
  if valid_589364 != nil:
    section.add "parent", valid_589364
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
  var valid_589365 = query.getOrDefault("upload_protocol")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "upload_protocol", valid_589365
  var valid_589366 = query.getOrDefault("fields")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "fields", valid_589366
  var valid_589367 = query.getOrDefault("quotaUser")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "quotaUser", valid_589367
  var valid_589368 = query.getOrDefault("alt")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = newJString("json"))
  if valid_589368 != nil:
    section.add "alt", valid_589368
  var valid_589369 = query.getOrDefault("oauth_token")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "oauth_token", valid_589369
  var valid_589370 = query.getOrDefault("callback")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "callback", valid_589370
  var valid_589371 = query.getOrDefault("access_token")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "access_token", valid_589371
  var valid_589372 = query.getOrDefault("uploadType")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "uploadType", valid_589372
  var valid_589373 = query.getOrDefault("key")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "key", valid_589373
  var valid_589374 = query.getOrDefault("$.xgafv")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = newJString("1"))
  if valid_589374 != nil:
    section.add "$.xgafv", valid_589374
  var valid_589375 = query.getOrDefault("prettyPrint")
  valid_589375 = validateParameter(valid_589375, JBool, required = false,
                                 default = newJBool(true))
  if valid_589375 != nil:
    section.add "prettyPrint", valid_589375
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

proc call*(call_589377: Call_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_589361;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or creates multiple entities in the specified entity type. This
  ## method does not affect entities in the entity type that aren't explicitly
  ## specified in the request.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_589377.validator(path, query, header, formData, body)
  let scheme = call_589377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589377.url(scheme.get, call_589377.host, call_589377.base,
                         call_589377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589377, url, valid)

proc call*(call_589378: Call_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_589361;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentEntityTypesEntitiesBatchUpdate
  ## Updates or creates multiple entities in the specified entity type. This
  ## method does not affect entities in the entity type that aren't explicitly
  ## specified in the request.
  ## 
  ## Operation <response: google.protobuf.Empty>
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
  ##   parent: string (required)
  ##         : Required. The name of the entity type to update or create entities in.
  ## Format: `projects/<Project ID>/agent/entityTypes/<Entity Type ID>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589379 = newJObject()
  var query_589380 = newJObject()
  var body_589381 = newJObject()
  add(query_589380, "upload_protocol", newJString(uploadProtocol))
  add(query_589380, "fields", newJString(fields))
  add(query_589380, "quotaUser", newJString(quotaUser))
  add(query_589380, "alt", newJString(alt))
  add(query_589380, "oauth_token", newJString(oauthToken))
  add(query_589380, "callback", newJString(callback))
  add(query_589380, "access_token", newJString(accessToken))
  add(query_589380, "uploadType", newJString(uploadType))
  add(path_589379, "parent", newJString(parent))
  add(query_589380, "key", newJString(key))
  add(query_589380, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589381 = body
  add(query_589380, "prettyPrint", newJBool(prettyPrint))
  result = call_589378.call(path_589379, query_589380, nil, nil, body_589381)

var dialogflowProjectsAgentEntityTypesEntitiesBatchUpdate* = Call_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_589361(
    name: "dialogflowProjectsAgentEntityTypesEntitiesBatchUpdate",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/entities:batchUpdate",
    validator: validate_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_589362,
    base: "/", url: url_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_589363,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesCreate_589404 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentEntityTypesCreate_589406(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entityTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesCreate_589405(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an entity type in the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The agent to create a entity type for.
  ## Format: `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589407 = path.getOrDefault("parent")
  valid_589407 = validateParameter(valid_589407, JString, required = true,
                                 default = nil)
  if valid_589407 != nil:
    section.add "parent", valid_589407
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
  ##   languageCode: JString
  ##               : Optional. The language of entity synonyms defined in `entity_type`. If not
  ## specified, the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589408 = query.getOrDefault("upload_protocol")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "upload_protocol", valid_589408
  var valid_589409 = query.getOrDefault("fields")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "fields", valid_589409
  var valid_589410 = query.getOrDefault("quotaUser")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "quotaUser", valid_589410
  var valid_589411 = query.getOrDefault("alt")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = newJString("json"))
  if valid_589411 != nil:
    section.add "alt", valid_589411
  var valid_589412 = query.getOrDefault("oauth_token")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "oauth_token", valid_589412
  var valid_589413 = query.getOrDefault("callback")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "callback", valid_589413
  var valid_589414 = query.getOrDefault("access_token")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "access_token", valid_589414
  var valid_589415 = query.getOrDefault("uploadType")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "uploadType", valid_589415
  var valid_589416 = query.getOrDefault("key")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "key", valid_589416
  var valid_589417 = query.getOrDefault("$.xgafv")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = newJString("1"))
  if valid_589417 != nil:
    section.add "$.xgafv", valid_589417
  var valid_589418 = query.getOrDefault("languageCode")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "languageCode", valid_589418
  var valid_589419 = query.getOrDefault("prettyPrint")
  valid_589419 = validateParameter(valid_589419, JBool, required = false,
                                 default = newJBool(true))
  if valid_589419 != nil:
    section.add "prettyPrint", valid_589419
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

proc call*(call_589421: Call_DialogflowProjectsAgentEntityTypesCreate_589404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an entity type in the specified agent.
  ## 
  let valid = call_589421.validator(path, query, header, formData, body)
  let scheme = call_589421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589421.url(scheme.get, call_589421.host, call_589421.base,
                         call_589421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589421, url, valid)

proc call*(call_589422: Call_DialogflowProjectsAgentEntityTypesCreate_589404;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; languageCode: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentEntityTypesCreate
  ## Creates an entity type in the specified agent.
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
  ##   parent: string (required)
  ##         : Required. The agent to create a entity type for.
  ## Format: `projects/<Project ID>/agent`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCode: string
  ##               : Optional. The language of entity synonyms defined in `entity_type`. If not
  ## specified, the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589423 = newJObject()
  var query_589424 = newJObject()
  var body_589425 = newJObject()
  add(query_589424, "upload_protocol", newJString(uploadProtocol))
  add(query_589424, "fields", newJString(fields))
  add(query_589424, "quotaUser", newJString(quotaUser))
  add(query_589424, "alt", newJString(alt))
  add(query_589424, "oauth_token", newJString(oauthToken))
  add(query_589424, "callback", newJString(callback))
  add(query_589424, "access_token", newJString(accessToken))
  add(query_589424, "uploadType", newJString(uploadType))
  add(path_589423, "parent", newJString(parent))
  add(query_589424, "key", newJString(key))
  add(query_589424, "$.xgafv", newJString(Xgafv))
  add(query_589424, "languageCode", newJString(languageCode))
  if body != nil:
    body_589425 = body
  add(query_589424, "prettyPrint", newJBool(prettyPrint))
  result = call_589422.call(path_589423, query_589424, nil, nil, body_589425)

var dialogflowProjectsAgentEntityTypesCreate* = Call_DialogflowProjectsAgentEntityTypesCreate_589404(
    name: "dialogflowProjectsAgentEntityTypesCreate", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/entityTypes",
    validator: validate_DialogflowProjectsAgentEntityTypesCreate_589405,
    base: "/", url: url_DialogflowProjectsAgentEntityTypesCreate_589406,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesList_589382 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentEntityTypesList_589384(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entityTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesList_589383(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of all entity types in the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The agent to list all entity types from.
  ## Format: `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589385 = path.getOrDefault("parent")
  valid_589385 = validateParameter(valid_589385, JString, required = true,
                                 default = nil)
  if valid_589385 != nil:
    section.add "parent", valid_589385
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. The next_page_token value returned from a previous list request.
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
  ##   languageCode: JString
  ##               : Optional. The language to list entity synonyms for. If not specified,
  ## the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589386 = query.getOrDefault("upload_protocol")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "upload_protocol", valid_589386
  var valid_589387 = query.getOrDefault("fields")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "fields", valid_589387
  var valid_589388 = query.getOrDefault("pageToken")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "pageToken", valid_589388
  var valid_589389 = query.getOrDefault("quotaUser")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "quotaUser", valid_589389
  var valid_589390 = query.getOrDefault("alt")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = newJString("json"))
  if valid_589390 != nil:
    section.add "alt", valid_589390
  var valid_589391 = query.getOrDefault("oauth_token")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "oauth_token", valid_589391
  var valid_589392 = query.getOrDefault("callback")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "callback", valid_589392
  var valid_589393 = query.getOrDefault("access_token")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "access_token", valid_589393
  var valid_589394 = query.getOrDefault("uploadType")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "uploadType", valid_589394
  var valid_589395 = query.getOrDefault("key")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "key", valid_589395
  var valid_589396 = query.getOrDefault("$.xgafv")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = newJString("1"))
  if valid_589396 != nil:
    section.add "$.xgafv", valid_589396
  var valid_589397 = query.getOrDefault("languageCode")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "languageCode", valid_589397
  var valid_589398 = query.getOrDefault("pageSize")
  valid_589398 = validateParameter(valid_589398, JInt, required = false, default = nil)
  if valid_589398 != nil:
    section.add "pageSize", valid_589398
  var valid_589399 = query.getOrDefault("prettyPrint")
  valid_589399 = validateParameter(valid_589399, JBool, required = false,
                                 default = newJBool(true))
  if valid_589399 != nil:
    section.add "prettyPrint", valid_589399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589400: Call_DialogflowProjectsAgentEntityTypesList_589382;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of all entity types in the specified agent.
  ## 
  let valid = call_589400.validator(path, query, header, formData, body)
  let scheme = call_589400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589400.url(scheme.get, call_589400.host, call_589400.base,
                         call_589400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589400, url, valid)

proc call*(call_589401: Call_DialogflowProjectsAgentEntityTypesList_589382;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          languageCode: string = ""; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentEntityTypesList
  ## Returns the list of all entity types in the specified agent.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. The next_page_token value returned from a previous list request.
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
  ##   parent: string (required)
  ##         : Required. The agent to list all entity types from.
  ## Format: `projects/<Project ID>/agent`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCode: string
  ##               : Optional. The language to list entity synonyms for. If not specified,
  ## the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   pageSize: int
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589402 = newJObject()
  var query_589403 = newJObject()
  add(query_589403, "upload_protocol", newJString(uploadProtocol))
  add(query_589403, "fields", newJString(fields))
  add(query_589403, "pageToken", newJString(pageToken))
  add(query_589403, "quotaUser", newJString(quotaUser))
  add(query_589403, "alt", newJString(alt))
  add(query_589403, "oauth_token", newJString(oauthToken))
  add(query_589403, "callback", newJString(callback))
  add(query_589403, "access_token", newJString(accessToken))
  add(query_589403, "uploadType", newJString(uploadType))
  add(path_589402, "parent", newJString(parent))
  add(query_589403, "key", newJString(key))
  add(query_589403, "$.xgafv", newJString(Xgafv))
  add(query_589403, "languageCode", newJString(languageCode))
  add(query_589403, "pageSize", newJInt(pageSize))
  add(query_589403, "prettyPrint", newJBool(prettyPrint))
  result = call_589401.call(path_589402, query_589403, nil, nil, nil)

var dialogflowProjectsAgentEntityTypesList* = Call_DialogflowProjectsAgentEntityTypesList_589382(
    name: "dialogflowProjectsAgentEntityTypesList", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/entityTypes",
    validator: validate_DialogflowProjectsAgentEntityTypesList_589383, base: "/",
    url: url_DialogflowProjectsAgentEntityTypesList_589384,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesBatchDelete_589426 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentEntityTypesBatchDelete_589428(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entityTypes:batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesBatchDelete_589427(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes entity types in the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the agent to delete all entities types for. Format:
  ## `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589429 = path.getOrDefault("parent")
  valid_589429 = validateParameter(valid_589429, JString, required = true,
                                 default = nil)
  if valid_589429 != nil:
    section.add "parent", valid_589429
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
  var valid_589430 = query.getOrDefault("upload_protocol")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "upload_protocol", valid_589430
  var valid_589431 = query.getOrDefault("fields")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "fields", valid_589431
  var valid_589432 = query.getOrDefault("quotaUser")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "quotaUser", valid_589432
  var valid_589433 = query.getOrDefault("alt")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = newJString("json"))
  if valid_589433 != nil:
    section.add "alt", valid_589433
  var valid_589434 = query.getOrDefault("oauth_token")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "oauth_token", valid_589434
  var valid_589435 = query.getOrDefault("callback")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "callback", valid_589435
  var valid_589436 = query.getOrDefault("access_token")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "access_token", valid_589436
  var valid_589437 = query.getOrDefault("uploadType")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "uploadType", valid_589437
  var valid_589438 = query.getOrDefault("key")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "key", valid_589438
  var valid_589439 = query.getOrDefault("$.xgafv")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = newJString("1"))
  if valid_589439 != nil:
    section.add "$.xgafv", valid_589439
  var valid_589440 = query.getOrDefault("prettyPrint")
  valid_589440 = validateParameter(valid_589440, JBool, required = false,
                                 default = newJBool(true))
  if valid_589440 != nil:
    section.add "prettyPrint", valid_589440
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

proc call*(call_589442: Call_DialogflowProjectsAgentEntityTypesBatchDelete_589426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes entity types in the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_589442.validator(path, query, header, formData, body)
  let scheme = call_589442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589442.url(scheme.get, call_589442.host, call_589442.base,
                         call_589442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589442, url, valid)

proc call*(call_589443: Call_DialogflowProjectsAgentEntityTypesBatchDelete_589426;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentEntityTypesBatchDelete
  ## Deletes entity types in the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
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
  ##   parent: string (required)
  ##         : Required. The name of the agent to delete all entities types for. Format:
  ## `projects/<Project ID>/agent`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589444 = newJObject()
  var query_589445 = newJObject()
  var body_589446 = newJObject()
  add(query_589445, "upload_protocol", newJString(uploadProtocol))
  add(query_589445, "fields", newJString(fields))
  add(query_589445, "quotaUser", newJString(quotaUser))
  add(query_589445, "alt", newJString(alt))
  add(query_589445, "oauth_token", newJString(oauthToken))
  add(query_589445, "callback", newJString(callback))
  add(query_589445, "access_token", newJString(accessToken))
  add(query_589445, "uploadType", newJString(uploadType))
  add(path_589444, "parent", newJString(parent))
  add(query_589445, "key", newJString(key))
  add(query_589445, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589446 = body
  add(query_589445, "prettyPrint", newJBool(prettyPrint))
  result = call_589443.call(path_589444, query_589445, nil, nil, body_589446)

var dialogflowProjectsAgentEntityTypesBatchDelete* = Call_DialogflowProjectsAgentEntityTypesBatchDelete_589426(
    name: "dialogflowProjectsAgentEntityTypesBatchDelete",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/entityTypes:batchDelete",
    validator: validate_DialogflowProjectsAgentEntityTypesBatchDelete_589427,
    base: "/", url: url_DialogflowProjectsAgentEntityTypesBatchDelete_589428,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesBatchUpdate_589447 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentEntityTypesBatchUpdate_589449(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entityTypes:batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesBatchUpdate_589448(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates/Creates multiple entity types in the specified agent.
  ## 
  ## Operation <response: BatchUpdateEntityTypesResponse>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the agent to update or create entity types in.
  ## Format: `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589450 = path.getOrDefault("parent")
  valid_589450 = validateParameter(valid_589450, JString, required = true,
                                 default = nil)
  if valid_589450 != nil:
    section.add "parent", valid_589450
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
  var valid_589451 = query.getOrDefault("upload_protocol")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "upload_protocol", valid_589451
  var valid_589452 = query.getOrDefault("fields")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "fields", valid_589452
  var valid_589453 = query.getOrDefault("quotaUser")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "quotaUser", valid_589453
  var valid_589454 = query.getOrDefault("alt")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = newJString("json"))
  if valid_589454 != nil:
    section.add "alt", valid_589454
  var valid_589455 = query.getOrDefault("oauth_token")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "oauth_token", valid_589455
  var valid_589456 = query.getOrDefault("callback")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "callback", valid_589456
  var valid_589457 = query.getOrDefault("access_token")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "access_token", valid_589457
  var valid_589458 = query.getOrDefault("uploadType")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "uploadType", valid_589458
  var valid_589459 = query.getOrDefault("key")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "key", valid_589459
  var valid_589460 = query.getOrDefault("$.xgafv")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = newJString("1"))
  if valid_589460 != nil:
    section.add "$.xgafv", valid_589460
  var valid_589461 = query.getOrDefault("prettyPrint")
  valid_589461 = validateParameter(valid_589461, JBool, required = false,
                                 default = newJBool(true))
  if valid_589461 != nil:
    section.add "prettyPrint", valid_589461
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

proc call*(call_589463: Call_DialogflowProjectsAgentEntityTypesBatchUpdate_589447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates/Creates multiple entity types in the specified agent.
  ## 
  ## Operation <response: BatchUpdateEntityTypesResponse>
  ## 
  let valid = call_589463.validator(path, query, header, formData, body)
  let scheme = call_589463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589463.url(scheme.get, call_589463.host, call_589463.base,
                         call_589463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589463, url, valid)

proc call*(call_589464: Call_DialogflowProjectsAgentEntityTypesBatchUpdate_589447;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentEntityTypesBatchUpdate
  ## Updates/Creates multiple entity types in the specified agent.
  ## 
  ## Operation <response: BatchUpdateEntityTypesResponse>
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
  ##   parent: string (required)
  ##         : Required. The name of the agent to update or create entity types in.
  ## Format: `projects/<Project ID>/agent`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589465 = newJObject()
  var query_589466 = newJObject()
  var body_589467 = newJObject()
  add(query_589466, "upload_protocol", newJString(uploadProtocol))
  add(query_589466, "fields", newJString(fields))
  add(query_589466, "quotaUser", newJString(quotaUser))
  add(query_589466, "alt", newJString(alt))
  add(query_589466, "oauth_token", newJString(oauthToken))
  add(query_589466, "callback", newJString(callback))
  add(query_589466, "access_token", newJString(accessToken))
  add(query_589466, "uploadType", newJString(uploadType))
  add(path_589465, "parent", newJString(parent))
  add(query_589466, "key", newJString(key))
  add(query_589466, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589467 = body
  add(query_589466, "prettyPrint", newJBool(prettyPrint))
  result = call_589464.call(path_589465, query_589466, nil, nil, body_589467)

var dialogflowProjectsAgentEntityTypesBatchUpdate* = Call_DialogflowProjectsAgentEntityTypesBatchUpdate_589447(
    name: "dialogflowProjectsAgentEntityTypesBatchUpdate",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/entityTypes:batchUpdate",
    validator: validate_DialogflowProjectsAgentEntityTypesBatchUpdate_589448,
    base: "/", url: url_DialogflowProjectsAgentEntityTypesBatchUpdate_589449,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentIntentsCreate_589491 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentIntentsCreate_589493(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/intents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentIntentsCreate_589492(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an intent in the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The agent to create a intent for.
  ## Format: `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589494 = path.getOrDefault("parent")
  valid_589494 = validateParameter(valid_589494, JString, required = true,
                                 default = nil)
  if valid_589494 != nil:
    section.add "parent", valid_589494
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
  ##   intentView: JString
  ##             : Optional. The resource view to apply to the returned intent.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   languageCode: JString
  ##               : Optional. The language of training phrases, parameters and rich messages
  ## defined in `intent`. If not specified, the agent's default language is
  ## used. [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589495 = query.getOrDefault("upload_protocol")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "upload_protocol", valid_589495
  var valid_589496 = query.getOrDefault("fields")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "fields", valid_589496
  var valid_589497 = query.getOrDefault("quotaUser")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = nil)
  if valid_589497 != nil:
    section.add "quotaUser", valid_589497
  var valid_589498 = query.getOrDefault("alt")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = newJString("json"))
  if valid_589498 != nil:
    section.add "alt", valid_589498
  var valid_589499 = query.getOrDefault("oauth_token")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "oauth_token", valid_589499
  var valid_589500 = query.getOrDefault("callback")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "callback", valid_589500
  var valid_589501 = query.getOrDefault("access_token")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "access_token", valid_589501
  var valid_589502 = query.getOrDefault("uploadType")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "uploadType", valid_589502
  var valid_589503 = query.getOrDefault("intentView")
  valid_589503 = validateParameter(valid_589503, JString, required = false, default = newJString(
      "INTENT_VIEW_UNSPECIFIED"))
  if valid_589503 != nil:
    section.add "intentView", valid_589503
  var valid_589504 = query.getOrDefault("key")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "key", valid_589504
  var valid_589505 = query.getOrDefault("$.xgafv")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = newJString("1"))
  if valid_589505 != nil:
    section.add "$.xgafv", valid_589505
  var valid_589506 = query.getOrDefault("languageCode")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = nil)
  if valid_589506 != nil:
    section.add "languageCode", valid_589506
  var valid_589507 = query.getOrDefault("prettyPrint")
  valid_589507 = validateParameter(valid_589507, JBool, required = false,
                                 default = newJBool(true))
  if valid_589507 != nil:
    section.add "prettyPrint", valid_589507
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

proc call*(call_589509: Call_DialogflowProjectsAgentIntentsCreate_589491;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an intent in the specified agent.
  ## 
  let valid = call_589509.validator(path, query, header, formData, body)
  let scheme = call_589509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589509.url(scheme.get, call_589509.host, call_589509.base,
                         call_589509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589509, url, valid)

proc call*(call_589510: Call_DialogflowProjectsAgentIntentsCreate_589491;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          intentView: string = "INTENT_VIEW_UNSPECIFIED"; key: string = "";
          Xgafv: string = "1"; languageCode: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentIntentsCreate
  ## Creates an intent in the specified agent.
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
  ##   parent: string (required)
  ##         : Required. The agent to create a intent for.
  ## Format: `projects/<Project ID>/agent`.
  ##   intentView: string
  ##             : Optional. The resource view to apply to the returned intent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCode: string
  ##               : Optional. The language of training phrases, parameters and rich messages
  ## defined in `intent`. If not specified, the agent's default language is
  ## used. [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589511 = newJObject()
  var query_589512 = newJObject()
  var body_589513 = newJObject()
  add(query_589512, "upload_protocol", newJString(uploadProtocol))
  add(query_589512, "fields", newJString(fields))
  add(query_589512, "quotaUser", newJString(quotaUser))
  add(query_589512, "alt", newJString(alt))
  add(query_589512, "oauth_token", newJString(oauthToken))
  add(query_589512, "callback", newJString(callback))
  add(query_589512, "access_token", newJString(accessToken))
  add(query_589512, "uploadType", newJString(uploadType))
  add(path_589511, "parent", newJString(parent))
  add(query_589512, "intentView", newJString(intentView))
  add(query_589512, "key", newJString(key))
  add(query_589512, "$.xgafv", newJString(Xgafv))
  add(query_589512, "languageCode", newJString(languageCode))
  if body != nil:
    body_589513 = body
  add(query_589512, "prettyPrint", newJBool(prettyPrint))
  result = call_589510.call(path_589511, query_589512, nil, nil, body_589513)

var dialogflowProjectsAgentIntentsCreate* = Call_DialogflowProjectsAgentIntentsCreate_589491(
    name: "dialogflowProjectsAgentIntentsCreate", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/intents",
    validator: validate_DialogflowProjectsAgentIntentsCreate_589492, base: "/",
    url: url_DialogflowProjectsAgentIntentsCreate_589493, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentIntentsList_589468 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentIntentsList_589470(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/intents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentIntentsList_589469(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of all intents in the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The agent to list all intents from.
  ## Format: `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589471 = path.getOrDefault("parent")
  valid_589471 = validateParameter(valid_589471, JString, required = true,
                                 default = nil)
  if valid_589471 != nil:
    section.add "parent", valid_589471
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. The next_page_token value returned from a previous list request.
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
  ##   intentView: JString
  ##             : Optional. The resource view to apply to the returned intent.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   languageCode: JString
  ##               : Optional. The language to list training phrases, parameters and rich
  ## messages for. If not specified, the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589472 = query.getOrDefault("upload_protocol")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "upload_protocol", valid_589472
  var valid_589473 = query.getOrDefault("fields")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "fields", valid_589473
  var valid_589474 = query.getOrDefault("pageToken")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "pageToken", valid_589474
  var valid_589475 = query.getOrDefault("quotaUser")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "quotaUser", valid_589475
  var valid_589476 = query.getOrDefault("alt")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = newJString("json"))
  if valid_589476 != nil:
    section.add "alt", valid_589476
  var valid_589477 = query.getOrDefault("oauth_token")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "oauth_token", valid_589477
  var valid_589478 = query.getOrDefault("callback")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "callback", valid_589478
  var valid_589479 = query.getOrDefault("access_token")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "access_token", valid_589479
  var valid_589480 = query.getOrDefault("uploadType")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = nil)
  if valid_589480 != nil:
    section.add "uploadType", valid_589480
  var valid_589481 = query.getOrDefault("intentView")
  valid_589481 = validateParameter(valid_589481, JString, required = false, default = newJString(
      "INTENT_VIEW_UNSPECIFIED"))
  if valid_589481 != nil:
    section.add "intentView", valid_589481
  var valid_589482 = query.getOrDefault("key")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "key", valid_589482
  var valid_589483 = query.getOrDefault("$.xgafv")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = newJString("1"))
  if valid_589483 != nil:
    section.add "$.xgafv", valid_589483
  var valid_589484 = query.getOrDefault("languageCode")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "languageCode", valid_589484
  var valid_589485 = query.getOrDefault("pageSize")
  valid_589485 = validateParameter(valid_589485, JInt, required = false, default = nil)
  if valid_589485 != nil:
    section.add "pageSize", valid_589485
  var valid_589486 = query.getOrDefault("prettyPrint")
  valid_589486 = validateParameter(valid_589486, JBool, required = false,
                                 default = newJBool(true))
  if valid_589486 != nil:
    section.add "prettyPrint", valid_589486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589487: Call_DialogflowProjectsAgentIntentsList_589468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of all intents in the specified agent.
  ## 
  let valid = call_589487.validator(path, query, header, formData, body)
  let scheme = call_589487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589487.url(scheme.get, call_589487.host, call_589487.base,
                         call_589487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589487, url, valid)

proc call*(call_589488: Call_DialogflowProjectsAgentIntentsList_589468;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; intentView: string = "INTENT_VIEW_UNSPECIFIED";
          key: string = ""; Xgafv: string = "1"; languageCode: string = "";
          pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentIntentsList
  ## Returns the list of all intents in the specified agent.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. The next_page_token value returned from a previous list request.
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
  ##   parent: string (required)
  ##         : Required. The agent to list all intents from.
  ## Format: `projects/<Project ID>/agent`.
  ##   intentView: string
  ##             : Optional. The resource view to apply to the returned intent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   languageCode: string
  ##               : Optional. The language to list training phrases, parameters and rich
  ## messages for. If not specified, the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   pageSize: int
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589489 = newJObject()
  var query_589490 = newJObject()
  add(query_589490, "upload_protocol", newJString(uploadProtocol))
  add(query_589490, "fields", newJString(fields))
  add(query_589490, "pageToken", newJString(pageToken))
  add(query_589490, "quotaUser", newJString(quotaUser))
  add(query_589490, "alt", newJString(alt))
  add(query_589490, "oauth_token", newJString(oauthToken))
  add(query_589490, "callback", newJString(callback))
  add(query_589490, "access_token", newJString(accessToken))
  add(query_589490, "uploadType", newJString(uploadType))
  add(path_589489, "parent", newJString(parent))
  add(query_589490, "intentView", newJString(intentView))
  add(query_589490, "key", newJString(key))
  add(query_589490, "$.xgafv", newJString(Xgafv))
  add(query_589490, "languageCode", newJString(languageCode))
  add(query_589490, "pageSize", newJInt(pageSize))
  add(query_589490, "prettyPrint", newJBool(prettyPrint))
  result = call_589488.call(path_589489, query_589490, nil, nil, nil)

var dialogflowProjectsAgentIntentsList* = Call_DialogflowProjectsAgentIntentsList_589468(
    name: "dialogflowProjectsAgentIntentsList", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/intents",
    validator: validate_DialogflowProjectsAgentIntentsList_589469, base: "/",
    url: url_DialogflowProjectsAgentIntentsList_589470, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentIntentsBatchDelete_589514 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentIntentsBatchDelete_589516(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/intents:batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentIntentsBatchDelete_589515(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes intents in the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the agent to delete all entities types for. Format:
  ## `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589517 = path.getOrDefault("parent")
  valid_589517 = validateParameter(valid_589517, JString, required = true,
                                 default = nil)
  if valid_589517 != nil:
    section.add "parent", valid_589517
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
  var valid_589518 = query.getOrDefault("upload_protocol")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "upload_protocol", valid_589518
  var valid_589519 = query.getOrDefault("fields")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "fields", valid_589519
  var valid_589520 = query.getOrDefault("quotaUser")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "quotaUser", valid_589520
  var valid_589521 = query.getOrDefault("alt")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = newJString("json"))
  if valid_589521 != nil:
    section.add "alt", valid_589521
  var valid_589522 = query.getOrDefault("oauth_token")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "oauth_token", valid_589522
  var valid_589523 = query.getOrDefault("callback")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "callback", valid_589523
  var valid_589524 = query.getOrDefault("access_token")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "access_token", valid_589524
  var valid_589525 = query.getOrDefault("uploadType")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "uploadType", valid_589525
  var valid_589526 = query.getOrDefault("key")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "key", valid_589526
  var valid_589527 = query.getOrDefault("$.xgafv")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = newJString("1"))
  if valid_589527 != nil:
    section.add "$.xgafv", valid_589527
  var valid_589528 = query.getOrDefault("prettyPrint")
  valid_589528 = validateParameter(valid_589528, JBool, required = false,
                                 default = newJBool(true))
  if valid_589528 != nil:
    section.add "prettyPrint", valid_589528
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

proc call*(call_589530: Call_DialogflowProjectsAgentIntentsBatchDelete_589514;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes intents in the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_589530.validator(path, query, header, formData, body)
  let scheme = call_589530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589530.url(scheme.get, call_589530.host, call_589530.base,
                         call_589530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589530, url, valid)

proc call*(call_589531: Call_DialogflowProjectsAgentIntentsBatchDelete_589514;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentIntentsBatchDelete
  ## Deletes intents in the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
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
  ##   parent: string (required)
  ##         : Required. The name of the agent to delete all entities types for. Format:
  ## `projects/<Project ID>/agent`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589532 = newJObject()
  var query_589533 = newJObject()
  var body_589534 = newJObject()
  add(query_589533, "upload_protocol", newJString(uploadProtocol))
  add(query_589533, "fields", newJString(fields))
  add(query_589533, "quotaUser", newJString(quotaUser))
  add(query_589533, "alt", newJString(alt))
  add(query_589533, "oauth_token", newJString(oauthToken))
  add(query_589533, "callback", newJString(callback))
  add(query_589533, "access_token", newJString(accessToken))
  add(query_589533, "uploadType", newJString(uploadType))
  add(path_589532, "parent", newJString(parent))
  add(query_589533, "key", newJString(key))
  add(query_589533, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589534 = body
  add(query_589533, "prettyPrint", newJBool(prettyPrint))
  result = call_589531.call(path_589532, query_589533, nil, nil, body_589534)

var dialogflowProjectsAgentIntentsBatchDelete* = Call_DialogflowProjectsAgentIntentsBatchDelete_589514(
    name: "dialogflowProjectsAgentIntentsBatchDelete", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/intents:batchDelete",
    validator: validate_DialogflowProjectsAgentIntentsBatchDelete_589515,
    base: "/", url: url_DialogflowProjectsAgentIntentsBatchDelete_589516,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentIntentsBatchUpdate_589535 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentIntentsBatchUpdate_589537(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/intents:batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentIntentsBatchUpdate_589536(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates/Creates multiple intents in the specified agent.
  ## 
  ## Operation <response: BatchUpdateIntentsResponse>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the agent to update or create intents in.
  ## Format: `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589538 = path.getOrDefault("parent")
  valid_589538 = validateParameter(valid_589538, JString, required = true,
                                 default = nil)
  if valid_589538 != nil:
    section.add "parent", valid_589538
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
  var valid_589539 = query.getOrDefault("upload_protocol")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "upload_protocol", valid_589539
  var valid_589540 = query.getOrDefault("fields")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "fields", valid_589540
  var valid_589541 = query.getOrDefault("quotaUser")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "quotaUser", valid_589541
  var valid_589542 = query.getOrDefault("alt")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = newJString("json"))
  if valid_589542 != nil:
    section.add "alt", valid_589542
  var valid_589543 = query.getOrDefault("oauth_token")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "oauth_token", valid_589543
  var valid_589544 = query.getOrDefault("callback")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "callback", valid_589544
  var valid_589545 = query.getOrDefault("access_token")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "access_token", valid_589545
  var valid_589546 = query.getOrDefault("uploadType")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = nil)
  if valid_589546 != nil:
    section.add "uploadType", valid_589546
  var valid_589547 = query.getOrDefault("key")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "key", valid_589547
  var valid_589548 = query.getOrDefault("$.xgafv")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = newJString("1"))
  if valid_589548 != nil:
    section.add "$.xgafv", valid_589548
  var valid_589549 = query.getOrDefault("prettyPrint")
  valid_589549 = validateParameter(valid_589549, JBool, required = false,
                                 default = newJBool(true))
  if valid_589549 != nil:
    section.add "prettyPrint", valid_589549
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

proc call*(call_589551: Call_DialogflowProjectsAgentIntentsBatchUpdate_589535;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates/Creates multiple intents in the specified agent.
  ## 
  ## Operation <response: BatchUpdateIntentsResponse>
  ## 
  let valid = call_589551.validator(path, query, header, formData, body)
  let scheme = call_589551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589551.url(scheme.get, call_589551.host, call_589551.base,
                         call_589551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589551, url, valid)

proc call*(call_589552: Call_DialogflowProjectsAgentIntentsBatchUpdate_589535;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentIntentsBatchUpdate
  ## Updates/Creates multiple intents in the specified agent.
  ## 
  ## Operation <response: BatchUpdateIntentsResponse>
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
  ##   parent: string (required)
  ##         : Required. The name of the agent to update or create intents in.
  ## Format: `projects/<Project ID>/agent`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589553 = newJObject()
  var query_589554 = newJObject()
  var body_589555 = newJObject()
  add(query_589554, "upload_protocol", newJString(uploadProtocol))
  add(query_589554, "fields", newJString(fields))
  add(query_589554, "quotaUser", newJString(quotaUser))
  add(query_589554, "alt", newJString(alt))
  add(query_589554, "oauth_token", newJString(oauthToken))
  add(query_589554, "callback", newJString(callback))
  add(query_589554, "access_token", newJString(accessToken))
  add(query_589554, "uploadType", newJString(uploadType))
  add(path_589553, "parent", newJString(parent))
  add(query_589554, "key", newJString(key))
  add(query_589554, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589555 = body
  add(query_589554, "prettyPrint", newJBool(prettyPrint))
  result = call_589552.call(path_589553, query_589554, nil, nil, body_589555)

var dialogflowProjectsAgentIntentsBatchUpdate* = Call_DialogflowProjectsAgentIntentsBatchUpdate_589535(
    name: "dialogflowProjectsAgentIntentsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/intents:batchUpdate",
    validator: validate_DialogflowProjectsAgentIntentsBatchUpdate_589536,
    base: "/", url: url_DialogflowProjectsAgentIntentsBatchUpdate_589537,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentSessionsDetectIntent_589556 = ref object of OpenApiRestCall_588450
proc url_DialogflowProjectsAgentSessionsDetectIntent_589558(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":detectIntent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentSessionsDetectIntent_589557(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Processes a natural language query and returns structured, actionable data
  ## as a result. This method is not idempotent, because it may cause contexts
  ## and session entity types to be updated, which in turn might affect
  ## results of future queries.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The name of the session this query is sent to. Format:
  ## `projects/<Project ID>/agent/sessions/<Session ID>`. It's up to the API
  ## caller to choose an appropriate session ID. It can be a random number or
  ## some type of user identifier (preferably hashed). The length of the session
  ## ID must not exceed 36 bytes.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_589559 = path.getOrDefault("session")
  valid_589559 = validateParameter(valid_589559, JString, required = true,
                                 default = nil)
  if valid_589559 != nil:
    section.add "session", valid_589559
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
  var valid_589560 = query.getOrDefault("upload_protocol")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "upload_protocol", valid_589560
  var valid_589561 = query.getOrDefault("fields")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "fields", valid_589561
  var valid_589562 = query.getOrDefault("quotaUser")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "quotaUser", valid_589562
  var valid_589563 = query.getOrDefault("alt")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = newJString("json"))
  if valid_589563 != nil:
    section.add "alt", valid_589563
  var valid_589564 = query.getOrDefault("oauth_token")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "oauth_token", valid_589564
  var valid_589565 = query.getOrDefault("callback")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "callback", valid_589565
  var valid_589566 = query.getOrDefault("access_token")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "access_token", valid_589566
  var valid_589567 = query.getOrDefault("uploadType")
  valid_589567 = validateParameter(valid_589567, JString, required = false,
                                 default = nil)
  if valid_589567 != nil:
    section.add "uploadType", valid_589567
  var valid_589568 = query.getOrDefault("key")
  valid_589568 = validateParameter(valid_589568, JString, required = false,
                                 default = nil)
  if valid_589568 != nil:
    section.add "key", valid_589568
  var valid_589569 = query.getOrDefault("$.xgafv")
  valid_589569 = validateParameter(valid_589569, JString, required = false,
                                 default = newJString("1"))
  if valid_589569 != nil:
    section.add "$.xgafv", valid_589569
  var valid_589570 = query.getOrDefault("prettyPrint")
  valid_589570 = validateParameter(valid_589570, JBool, required = false,
                                 default = newJBool(true))
  if valid_589570 != nil:
    section.add "prettyPrint", valid_589570
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

proc call*(call_589572: Call_DialogflowProjectsAgentSessionsDetectIntent_589556;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Processes a natural language query and returns structured, actionable data
  ## as a result. This method is not idempotent, because it may cause contexts
  ## and session entity types to be updated, which in turn might affect
  ## results of future queries.
  ## 
  let valid = call_589572.validator(path, query, header, formData, body)
  let scheme = call_589572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589572.url(scheme.get, call_589572.host, call_589572.base,
                         call_589572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589572, url, valid)

proc call*(call_589573: Call_DialogflowProjectsAgentSessionsDetectIntent_589556;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dialogflowProjectsAgentSessionsDetectIntent
  ## Processes a natural language query and returns structured, actionable data
  ## as a result. This method is not idempotent, because it may cause contexts
  ## and session entity types to be updated, which in turn might affect
  ## results of future queries.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The name of the session this query is sent to. Format:
  ## `projects/<Project ID>/agent/sessions/<Session ID>`. It's up to the API
  ## caller to choose an appropriate session ID. It can be a random number or
  ## some type of user identifier (preferably hashed). The length of the session
  ## ID must not exceed 36 bytes.
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
  var path_589574 = newJObject()
  var query_589575 = newJObject()
  var body_589576 = newJObject()
  add(query_589575, "upload_protocol", newJString(uploadProtocol))
  add(path_589574, "session", newJString(session))
  add(query_589575, "fields", newJString(fields))
  add(query_589575, "quotaUser", newJString(quotaUser))
  add(query_589575, "alt", newJString(alt))
  add(query_589575, "oauth_token", newJString(oauthToken))
  add(query_589575, "callback", newJString(callback))
  add(query_589575, "access_token", newJString(accessToken))
  add(query_589575, "uploadType", newJString(uploadType))
  add(query_589575, "key", newJString(key))
  add(query_589575, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589576 = body
  add(query_589575, "prettyPrint", newJBool(prettyPrint))
  result = call_589573.call(path_589574, query_589575, nil, nil, body_589576)

var dialogflowProjectsAgentSessionsDetectIntent* = Call_DialogflowProjectsAgentSessionsDetectIntent_589556(
    name: "dialogflowProjectsAgentSessionsDetectIntent",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{session}:detectIntent",
    validator: validate_DialogflowProjectsAgentSessionsDetectIntent_589557,
    base: "/", url: url_DialogflowProjectsAgentSessionsDetectIntent_589558,
    schemes: {Scheme.Https})
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
