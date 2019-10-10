
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Container Analysis
## version: v1alpha1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## An implementation of the Grafeas API, which stores, and enables querying and retrieval of critical metadata about all of your software artifacts.
## 
## https://cloud.google.com/container-analysis/api/reference/rest/
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
  gcpServiceName = "containeranalysis"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContaineranalysisProvidersNotesGet_588719 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProvidersNotesGet_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesGet_588720(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the requested `Note`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note in the form of
  ## "providers/{provider_id}/notes/{NOTE_ID}"
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  var valid_588869 = query.getOrDefault("key")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "key", valid_588869
  var valid_588870 = query.getOrDefault("$.xgafv")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = newJString("1"))
  if valid_588870 != nil:
    section.add "$.xgafv", valid_588870
  var valid_588871 = query.getOrDefault("prettyPrint")
  valid_588871 = validateParameter(valid_588871, JBool, required = false,
                                 default = newJBool(true))
  if valid_588871 != nil:
    section.add "prettyPrint", valid_588871
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588894: Call_ContaineranalysisProvidersNotesGet_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the requested `Note`.
  ## 
  let valid = call_588894.validator(path, query, header, formData, body)
  let scheme = call_588894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588894.url(scheme.get, call_588894.host, call_588894.base,
                         call_588894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588894, url, valid)

proc call*(call_588965: Call_ContaineranalysisProvidersNotesGet_588719;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containeranalysisProvidersNotesGet
  ## Returns the requested `Note`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the note in the form of
  ## "providers/{provider_id}/notes/{NOTE_ID}"
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
  var path_588966 = newJObject()
  var query_588968 = newJObject()
  add(query_588968, "upload_protocol", newJString(uploadProtocol))
  add(query_588968, "fields", newJString(fields))
  add(query_588968, "quotaUser", newJString(quotaUser))
  add(path_588966, "name", newJString(name))
  add(query_588968, "alt", newJString(alt))
  add(query_588968, "oauth_token", newJString(oauthToken))
  add(query_588968, "callback", newJString(callback))
  add(query_588968, "access_token", newJString(accessToken))
  add(query_588968, "uploadType", newJString(uploadType))
  add(query_588968, "key", newJString(key))
  add(query_588968, "$.xgafv", newJString(Xgafv))
  add(query_588968, "prettyPrint", newJBool(prettyPrint))
  result = call_588965.call(path_588966, query_588968, nil, nil, nil)

var containeranalysisProvidersNotesGet* = Call_ContaineranalysisProvidersNotesGet_588719(
    name: "containeranalysisProvidersNotesGet", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_ContaineranalysisProvidersNotesGet_588720, base: "/",
    url: url_ContaineranalysisProvidersNotesGet_588721, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesPatch_589026 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProvidersNotesPatch_589028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesPatch_589027(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing `Note`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note.
  ## Should be of the form "projects/{provider_id}/notes/{note_id}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589029 = path.getOrDefault("name")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "name", valid_589029
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
  ##             : The fields to update.
  section = newJObject()
  var valid_589030 = query.getOrDefault("upload_protocol")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "upload_protocol", valid_589030
  var valid_589031 = query.getOrDefault("fields")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "fields", valid_589031
  var valid_589032 = query.getOrDefault("quotaUser")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "quotaUser", valid_589032
  var valid_589033 = query.getOrDefault("alt")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("json"))
  if valid_589033 != nil:
    section.add "alt", valid_589033
  var valid_589034 = query.getOrDefault("oauth_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "oauth_token", valid_589034
  var valid_589035 = query.getOrDefault("callback")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "callback", valid_589035
  var valid_589036 = query.getOrDefault("access_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "access_token", valid_589036
  var valid_589037 = query.getOrDefault("uploadType")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "uploadType", valid_589037
  var valid_589038 = query.getOrDefault("key")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "key", valid_589038
  var valid_589039 = query.getOrDefault("$.xgafv")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("1"))
  if valid_589039 != nil:
    section.add "$.xgafv", valid_589039
  var valid_589040 = query.getOrDefault("prettyPrint")
  valid_589040 = validateParameter(valid_589040, JBool, required = false,
                                 default = newJBool(true))
  if valid_589040 != nil:
    section.add "prettyPrint", valid_589040
  var valid_589041 = query.getOrDefault("updateMask")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "updateMask", valid_589041
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

proc call*(call_589043: Call_ContaineranalysisProvidersNotesPatch_589026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing `Note`.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_ContaineranalysisProvidersNotesPatch_589026;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## containeranalysisProvidersNotesPatch
  ## Updates an existing `Note`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the note.
  ## Should be of the form "projects/{provider_id}/notes/{note_id}".
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
  ##   updateMask: string
  ##             : The fields to update.
  var path_589045 = newJObject()
  var query_589046 = newJObject()
  var body_589047 = newJObject()
  add(query_589046, "upload_protocol", newJString(uploadProtocol))
  add(query_589046, "fields", newJString(fields))
  add(query_589046, "quotaUser", newJString(quotaUser))
  add(path_589045, "name", newJString(name))
  add(query_589046, "alt", newJString(alt))
  add(query_589046, "oauth_token", newJString(oauthToken))
  add(query_589046, "callback", newJString(callback))
  add(query_589046, "access_token", newJString(accessToken))
  add(query_589046, "uploadType", newJString(uploadType))
  add(query_589046, "key", newJString(key))
  add(query_589046, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589047 = body
  add(query_589046, "prettyPrint", newJBool(prettyPrint))
  add(query_589046, "updateMask", newJString(updateMask))
  result = call_589044.call(path_589045, query_589046, nil, nil, body_589047)

var containeranalysisProvidersNotesPatch* = Call_ContaineranalysisProvidersNotesPatch_589026(
    name: "containeranalysisProvidersNotesPatch", meth: HttpMethod.HttpPatch,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_ContaineranalysisProvidersNotesPatch_589027, base: "/",
    url: url_ContaineranalysisProvidersNotesPatch_589028, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesDelete_589007 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProvidersNotesDelete_589009(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesDelete_589008(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the given `Note` from the system.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note in the form of
  ## "providers/{provider_id}/notes/{NOTE_ID}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589010 = path.getOrDefault("name")
  valid_589010 = validateParameter(valid_589010, JString, required = true,
                                 default = nil)
  if valid_589010 != nil:
    section.add "name", valid_589010
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
  var valid_589011 = query.getOrDefault("upload_protocol")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "upload_protocol", valid_589011
  var valid_589012 = query.getOrDefault("fields")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "fields", valid_589012
  var valid_589013 = query.getOrDefault("quotaUser")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "quotaUser", valid_589013
  var valid_589014 = query.getOrDefault("alt")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("json"))
  if valid_589014 != nil:
    section.add "alt", valid_589014
  var valid_589015 = query.getOrDefault("oauth_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "oauth_token", valid_589015
  var valid_589016 = query.getOrDefault("callback")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "callback", valid_589016
  var valid_589017 = query.getOrDefault("access_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "access_token", valid_589017
  var valid_589018 = query.getOrDefault("uploadType")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "uploadType", valid_589018
  var valid_589019 = query.getOrDefault("key")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "key", valid_589019
  var valid_589020 = query.getOrDefault("$.xgafv")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("1"))
  if valid_589020 != nil:
    section.add "$.xgafv", valid_589020
  var valid_589021 = query.getOrDefault("prettyPrint")
  valid_589021 = validateParameter(valid_589021, JBool, required = false,
                                 default = newJBool(true))
  if valid_589021 != nil:
    section.add "prettyPrint", valid_589021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589022: Call_ContaineranalysisProvidersNotesDelete_589007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the given `Note` from the system.
  ## 
  let valid = call_589022.validator(path, query, header, formData, body)
  let scheme = call_589022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589022.url(scheme.get, call_589022.host, call_589022.base,
                         call_589022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589022, url, valid)

proc call*(call_589023: Call_ContaineranalysisProvidersNotesDelete_589007;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containeranalysisProvidersNotesDelete
  ## Deletes the given `Note` from the system.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the note in the form of
  ## "providers/{provider_id}/notes/{NOTE_ID}"
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
  var path_589024 = newJObject()
  var query_589025 = newJObject()
  add(query_589025, "upload_protocol", newJString(uploadProtocol))
  add(query_589025, "fields", newJString(fields))
  add(query_589025, "quotaUser", newJString(quotaUser))
  add(path_589024, "name", newJString(name))
  add(query_589025, "alt", newJString(alt))
  add(query_589025, "oauth_token", newJString(oauthToken))
  add(query_589025, "callback", newJString(callback))
  add(query_589025, "access_token", newJString(accessToken))
  add(query_589025, "uploadType", newJString(uploadType))
  add(query_589025, "key", newJString(key))
  add(query_589025, "$.xgafv", newJString(Xgafv))
  add(query_589025, "prettyPrint", newJBool(prettyPrint))
  result = call_589023.call(path_589024, query_589025, nil, nil, nil)

var containeranalysisProvidersNotesDelete* = Call_ContaineranalysisProvidersNotesDelete_589007(
    name: "containeranalysisProvidersNotesDelete", meth: HttpMethod.HttpDelete,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_ContaineranalysisProvidersNotesDelete_589008, base: "/",
    url: url_ContaineranalysisProvidersNotesDelete_589009, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesCreate_589071 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProvidersNotesCreate_589073(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesCreate_589072(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Note`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589074 = path.getOrDefault("name")
  valid_589074 = validateParameter(valid_589074, JString, required = true,
                                 default = nil)
  if valid_589074 != nil:
    section.add "name", valid_589074
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
  ##   noteId: JString
  ##         : The ID to use for this note.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589075 = query.getOrDefault("upload_protocol")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "upload_protocol", valid_589075
  var valid_589076 = query.getOrDefault("fields")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "fields", valid_589076
  var valid_589077 = query.getOrDefault("quotaUser")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "quotaUser", valid_589077
  var valid_589078 = query.getOrDefault("alt")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = newJString("json"))
  if valid_589078 != nil:
    section.add "alt", valid_589078
  var valid_589079 = query.getOrDefault("noteId")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "noteId", valid_589079
  var valid_589080 = query.getOrDefault("oauth_token")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "oauth_token", valid_589080
  var valid_589081 = query.getOrDefault("callback")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "callback", valid_589081
  var valid_589082 = query.getOrDefault("access_token")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "access_token", valid_589082
  var valid_589083 = query.getOrDefault("uploadType")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "uploadType", valid_589083
  var valid_589084 = query.getOrDefault("parent")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "parent", valid_589084
  var valid_589085 = query.getOrDefault("key")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "key", valid_589085
  var valid_589086 = query.getOrDefault("$.xgafv")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = newJString("1"))
  if valid_589086 != nil:
    section.add "$.xgafv", valid_589086
  var valid_589087 = query.getOrDefault("prettyPrint")
  valid_589087 = validateParameter(valid_589087, JBool, required = false,
                                 default = newJBool(true))
  if valid_589087 != nil:
    section.add "prettyPrint", valid_589087
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

proc call*(call_589089: Call_ContaineranalysisProvidersNotesCreate_589071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Note`.
  ## 
  let valid = call_589089.validator(path, query, header, formData, body)
  let scheme = call_589089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589089.url(scheme.get, call_589089.host, call_589089.base,
                         call_589089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589089, url, valid)

proc call*(call_589090: Call_ContaineranalysisProvidersNotesCreate_589071;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; noteId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; parent: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containeranalysisProvidersNotesCreate
  ## Creates a new `Note`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  ##   alt: string
  ##      : Data format for response.
  ##   noteId: string
  ##         : The ID to use for this note.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589091 = newJObject()
  var query_589092 = newJObject()
  var body_589093 = newJObject()
  add(query_589092, "upload_protocol", newJString(uploadProtocol))
  add(query_589092, "fields", newJString(fields))
  add(query_589092, "quotaUser", newJString(quotaUser))
  add(path_589091, "name", newJString(name))
  add(query_589092, "alt", newJString(alt))
  add(query_589092, "noteId", newJString(noteId))
  add(query_589092, "oauth_token", newJString(oauthToken))
  add(query_589092, "callback", newJString(callback))
  add(query_589092, "access_token", newJString(accessToken))
  add(query_589092, "uploadType", newJString(uploadType))
  add(query_589092, "parent", newJString(parent))
  add(query_589092, "key", newJString(key))
  add(query_589092, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589093 = body
  add(query_589092, "prettyPrint", newJBool(prettyPrint))
  result = call_589090.call(path_589091, query_589092, nil, nil, body_589093)

var containeranalysisProvidersNotesCreate* = Call_ContaineranalysisProvidersNotesCreate_589071(
    name: "containeranalysisProvidersNotesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}/notes",
    validator: validate_ContaineranalysisProvidersNotesCreate_589072, base: "/",
    url: url_ContaineranalysisProvidersNotesCreate_589073, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesList_589048 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProvidersNotesList_589050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesList_589049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all `Notes` for a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name field will contain the project Id for example:
  ## "providers/{provider_id}
  ## @Deprecated
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589051 = path.getOrDefault("name")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "name", valid_589051
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##   parent: JString
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of notes to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_589052 = query.getOrDefault("upload_protocol")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "upload_protocol", valid_589052
  var valid_589053 = query.getOrDefault("fields")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "fields", valid_589053
  var valid_589054 = query.getOrDefault("pageToken")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "pageToken", valid_589054
  var valid_589055 = query.getOrDefault("quotaUser")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "quotaUser", valid_589055
  var valid_589056 = query.getOrDefault("alt")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("json"))
  if valid_589056 != nil:
    section.add "alt", valid_589056
  var valid_589057 = query.getOrDefault("oauth_token")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "oauth_token", valid_589057
  var valid_589058 = query.getOrDefault("callback")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "callback", valid_589058
  var valid_589059 = query.getOrDefault("access_token")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "access_token", valid_589059
  var valid_589060 = query.getOrDefault("uploadType")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "uploadType", valid_589060
  var valid_589061 = query.getOrDefault("parent")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "parent", valid_589061
  var valid_589062 = query.getOrDefault("key")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "key", valid_589062
  var valid_589063 = query.getOrDefault("$.xgafv")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("1"))
  if valid_589063 != nil:
    section.add "$.xgafv", valid_589063
  var valid_589064 = query.getOrDefault("pageSize")
  valid_589064 = validateParameter(valid_589064, JInt, required = false, default = nil)
  if valid_589064 != nil:
    section.add "pageSize", valid_589064
  var valid_589065 = query.getOrDefault("prettyPrint")
  valid_589065 = validateParameter(valid_589065, JBool, required = false,
                                 default = newJBool(true))
  if valid_589065 != nil:
    section.add "prettyPrint", valid_589065
  var valid_589066 = query.getOrDefault("filter")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "filter", valid_589066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589067: Call_ContaineranalysisProvidersNotesList_589048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all `Notes` for a given project.
  ## 
  let valid = call_589067.validator(path, query, header, formData, body)
  let scheme = call_589067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589067.url(scheme.get, call_589067.host, call_589067.base,
                         call_589067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589067, url, valid)

proc call*(call_589068: Call_ContaineranalysisProvidersNotesList_589048;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; parent: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## containeranalysisProvidersNotesList
  ## Lists all `Notes` for a given project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name field will contain the project Id for example:
  ## "providers/{provider_id}
  ## @Deprecated
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
  ##   parent: string
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of notes to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_589069 = newJObject()
  var query_589070 = newJObject()
  add(query_589070, "upload_protocol", newJString(uploadProtocol))
  add(query_589070, "fields", newJString(fields))
  add(query_589070, "pageToken", newJString(pageToken))
  add(query_589070, "quotaUser", newJString(quotaUser))
  add(path_589069, "name", newJString(name))
  add(query_589070, "alt", newJString(alt))
  add(query_589070, "oauth_token", newJString(oauthToken))
  add(query_589070, "callback", newJString(callback))
  add(query_589070, "access_token", newJString(accessToken))
  add(query_589070, "uploadType", newJString(uploadType))
  add(query_589070, "parent", newJString(parent))
  add(query_589070, "key", newJString(key))
  add(query_589070, "$.xgafv", newJString(Xgafv))
  add(query_589070, "pageSize", newJInt(pageSize))
  add(query_589070, "prettyPrint", newJBool(prettyPrint))
  add(query_589070, "filter", newJString(filter))
  result = call_589068.call(path_589069, query_589070, nil, nil, nil)

var containeranalysisProvidersNotesList* = Call_ContaineranalysisProvidersNotesList_589048(
    name: "containeranalysisProvidersNotesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}/notes",
    validator: validate_ContaineranalysisProvidersNotesList_589049, base: "/",
    url: url_ContaineranalysisProvidersNotesList_589050, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesOccurrencesList_589094 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProvidersNotesOccurrencesList_589096(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesOccurrencesList_589095(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists `Occurrences` referencing the specified `Note`. Use this method to
  ## get all occurrences referencing your `Note` across all your customer
  ## projects.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name field will contain the note name for example:
  ##   "provider/{provider_id}/notes/{note_id}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589097 = path.getOrDefault("name")
  valid_589097 = validateParameter(valid_589097, JString, required = true,
                                 default = nil)
  if valid_589097 != nil:
    section.add "name", valid_589097
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##           : Number of notes to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_589098 = query.getOrDefault("upload_protocol")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "upload_protocol", valid_589098
  var valid_589099 = query.getOrDefault("fields")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "fields", valid_589099
  var valid_589100 = query.getOrDefault("pageToken")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "pageToken", valid_589100
  var valid_589101 = query.getOrDefault("quotaUser")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "quotaUser", valid_589101
  var valid_589102 = query.getOrDefault("alt")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = newJString("json"))
  if valid_589102 != nil:
    section.add "alt", valid_589102
  var valid_589103 = query.getOrDefault("oauth_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "oauth_token", valid_589103
  var valid_589104 = query.getOrDefault("callback")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "callback", valid_589104
  var valid_589105 = query.getOrDefault("access_token")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "access_token", valid_589105
  var valid_589106 = query.getOrDefault("uploadType")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "uploadType", valid_589106
  var valid_589107 = query.getOrDefault("key")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "key", valid_589107
  var valid_589108 = query.getOrDefault("$.xgafv")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = newJString("1"))
  if valid_589108 != nil:
    section.add "$.xgafv", valid_589108
  var valid_589109 = query.getOrDefault("pageSize")
  valid_589109 = validateParameter(valid_589109, JInt, required = false, default = nil)
  if valid_589109 != nil:
    section.add "pageSize", valid_589109
  var valid_589110 = query.getOrDefault("prettyPrint")
  valid_589110 = validateParameter(valid_589110, JBool, required = false,
                                 default = newJBool(true))
  if valid_589110 != nil:
    section.add "prettyPrint", valid_589110
  var valid_589111 = query.getOrDefault("filter")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "filter", valid_589111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589112: Call_ContaineranalysisProvidersNotesOccurrencesList_589094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists `Occurrences` referencing the specified `Note`. Use this method to
  ## get all occurrences referencing your `Note` across all your customer
  ## projects.
  ## 
  let valid = call_589112.validator(path, query, header, formData, body)
  let scheme = call_589112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589112.url(scheme.get, call_589112.host, call_589112.base,
                         call_589112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589112, url, valid)

proc call*(call_589113: Call_ContaineranalysisProvidersNotesOccurrencesList_589094;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProvidersNotesOccurrencesList
  ## Lists `Occurrences` referencing the specified `Note`. Use this method to
  ## get all occurrences referencing your `Note` across all your customer
  ## projects.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name field will contain the note name for example:
  ##   "provider/{provider_id}/notes/{note_id}"
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
  ##           : Number of notes to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_589114 = newJObject()
  var query_589115 = newJObject()
  add(query_589115, "upload_protocol", newJString(uploadProtocol))
  add(query_589115, "fields", newJString(fields))
  add(query_589115, "pageToken", newJString(pageToken))
  add(query_589115, "quotaUser", newJString(quotaUser))
  add(path_589114, "name", newJString(name))
  add(query_589115, "alt", newJString(alt))
  add(query_589115, "oauth_token", newJString(oauthToken))
  add(query_589115, "callback", newJString(callback))
  add(query_589115, "access_token", newJString(accessToken))
  add(query_589115, "uploadType", newJString(uploadType))
  add(query_589115, "key", newJString(key))
  add(query_589115, "$.xgafv", newJString(Xgafv))
  add(query_589115, "pageSize", newJInt(pageSize))
  add(query_589115, "prettyPrint", newJBool(prettyPrint))
  add(query_589115, "filter", newJString(filter))
  result = call_589113.call(path_589114, query_589115, nil, nil, nil)

var containeranalysisProvidersNotesOccurrencesList* = Call_ContaineranalysisProvidersNotesOccurrencesList_589094(
    name: "containeranalysisProvidersNotesOccurrencesList",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{name}/occurrences",
    validator: validate_ContaineranalysisProvidersNotesOccurrencesList_589095,
    base: "/", url: url_ContaineranalysisProvidersNotesOccurrencesList_589096,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesCreate_589139 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsNotesCreate_589141(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesCreate_589140(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Note`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589142 = path.getOrDefault("parent")
  valid_589142 = validateParameter(valid_589142, JString, required = true,
                                 default = nil)
  if valid_589142 != nil:
    section.add "parent", valid_589142
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
  ##   noteId: JString
  ##         : The ID to use for this note.
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
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589143 = query.getOrDefault("upload_protocol")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "upload_protocol", valid_589143
  var valid_589144 = query.getOrDefault("fields")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "fields", valid_589144
  var valid_589145 = query.getOrDefault("quotaUser")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "quotaUser", valid_589145
  var valid_589146 = query.getOrDefault("alt")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = newJString("json"))
  if valid_589146 != nil:
    section.add "alt", valid_589146
  var valid_589147 = query.getOrDefault("noteId")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "noteId", valid_589147
  var valid_589148 = query.getOrDefault("oauth_token")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "oauth_token", valid_589148
  var valid_589149 = query.getOrDefault("callback")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "callback", valid_589149
  var valid_589150 = query.getOrDefault("access_token")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "access_token", valid_589150
  var valid_589151 = query.getOrDefault("uploadType")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "uploadType", valid_589151
  var valid_589152 = query.getOrDefault("key")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "key", valid_589152
  var valid_589153 = query.getOrDefault("name")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "name", valid_589153
  var valid_589154 = query.getOrDefault("$.xgafv")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = newJString("1"))
  if valid_589154 != nil:
    section.add "$.xgafv", valid_589154
  var valid_589155 = query.getOrDefault("prettyPrint")
  valid_589155 = validateParameter(valid_589155, JBool, required = false,
                                 default = newJBool(true))
  if valid_589155 != nil:
    section.add "prettyPrint", valid_589155
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

proc call*(call_589157: Call_ContaineranalysisProjectsNotesCreate_589139;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Note`.
  ## 
  let valid = call_589157.validator(path, query, header, formData, body)
  let scheme = call_589157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589157.url(scheme.get, call_589157.host, call_589157.base,
                         call_589157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589157, url, valid)

proc call*(call_589158: Call_ContaineranalysisProjectsNotesCreate_589139;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; noteId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; name: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesCreate
  ## Creates a new `Note`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   noteId: string
  ##         : The ID to use for this note.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589159 = newJObject()
  var query_589160 = newJObject()
  var body_589161 = newJObject()
  add(query_589160, "upload_protocol", newJString(uploadProtocol))
  add(query_589160, "fields", newJString(fields))
  add(query_589160, "quotaUser", newJString(quotaUser))
  add(query_589160, "alt", newJString(alt))
  add(query_589160, "noteId", newJString(noteId))
  add(query_589160, "oauth_token", newJString(oauthToken))
  add(query_589160, "callback", newJString(callback))
  add(query_589160, "access_token", newJString(accessToken))
  add(query_589160, "uploadType", newJString(uploadType))
  add(path_589159, "parent", newJString(parent))
  add(query_589160, "key", newJString(key))
  add(query_589160, "name", newJString(name))
  add(query_589160, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589161 = body
  add(query_589160, "prettyPrint", newJBool(prettyPrint))
  result = call_589158.call(path_589159, query_589160, nil, nil, body_589161)

var containeranalysisProjectsNotesCreate* = Call_ContaineranalysisProjectsNotesCreate_589139(
    name: "containeranalysisProjectsNotesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{parent}/notes",
    validator: validate_ContaineranalysisProjectsNotesCreate_589140, base: "/",
    url: url_ContaineranalysisProjectsNotesCreate_589141, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesList_589116 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsNotesList_589118(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesList_589117(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all `Notes` for a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589119 = path.getOrDefault("parent")
  valid_589119 = validateParameter(valid_589119, JString, required = true,
                                 default = nil)
  if valid_589119 != nil:
    section.add "parent", valid_589119
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##       : The name field will contain the project Id for example:
  ## "providers/{provider_id}
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of notes to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_589120 = query.getOrDefault("upload_protocol")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "upload_protocol", valid_589120
  var valid_589121 = query.getOrDefault("fields")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "fields", valid_589121
  var valid_589122 = query.getOrDefault("pageToken")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "pageToken", valid_589122
  var valid_589123 = query.getOrDefault("quotaUser")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "quotaUser", valid_589123
  var valid_589124 = query.getOrDefault("alt")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = newJString("json"))
  if valid_589124 != nil:
    section.add "alt", valid_589124
  var valid_589125 = query.getOrDefault("oauth_token")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "oauth_token", valid_589125
  var valid_589126 = query.getOrDefault("callback")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "callback", valid_589126
  var valid_589127 = query.getOrDefault("access_token")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "access_token", valid_589127
  var valid_589128 = query.getOrDefault("uploadType")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "uploadType", valid_589128
  var valid_589129 = query.getOrDefault("key")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "key", valid_589129
  var valid_589130 = query.getOrDefault("name")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "name", valid_589130
  var valid_589131 = query.getOrDefault("$.xgafv")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("1"))
  if valid_589131 != nil:
    section.add "$.xgafv", valid_589131
  var valid_589132 = query.getOrDefault("pageSize")
  valid_589132 = validateParameter(valid_589132, JInt, required = false, default = nil)
  if valid_589132 != nil:
    section.add "pageSize", valid_589132
  var valid_589133 = query.getOrDefault("prettyPrint")
  valid_589133 = validateParameter(valid_589133, JBool, required = false,
                                 default = newJBool(true))
  if valid_589133 != nil:
    section.add "prettyPrint", valid_589133
  var valid_589134 = query.getOrDefault("filter")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "filter", valid_589134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589135: Call_ContaineranalysisProjectsNotesList_589116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all `Notes` for a given project.
  ## 
  let valid = call_589135.validator(path, query, header, formData, body)
  let scheme = call_589135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589135.url(scheme.get, call_589135.host, call_589135.base,
                         call_589135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589135, url, valid)

proc call*(call_589136: Call_ContaineranalysisProjectsNotesList_589116;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; name: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsNotesList
  ## Lists all `Notes` for a given project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name field will contain the project Id for example:
  ## "providers/{provider_id}
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of notes to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_589137 = newJObject()
  var query_589138 = newJObject()
  add(query_589138, "upload_protocol", newJString(uploadProtocol))
  add(query_589138, "fields", newJString(fields))
  add(query_589138, "pageToken", newJString(pageToken))
  add(query_589138, "quotaUser", newJString(quotaUser))
  add(query_589138, "alt", newJString(alt))
  add(query_589138, "oauth_token", newJString(oauthToken))
  add(query_589138, "callback", newJString(callback))
  add(query_589138, "access_token", newJString(accessToken))
  add(query_589138, "uploadType", newJString(uploadType))
  add(path_589137, "parent", newJString(parent))
  add(query_589138, "key", newJString(key))
  add(query_589138, "name", newJString(name))
  add(query_589138, "$.xgafv", newJString(Xgafv))
  add(query_589138, "pageSize", newJInt(pageSize))
  add(query_589138, "prettyPrint", newJBool(prettyPrint))
  add(query_589138, "filter", newJString(filter))
  result = call_589136.call(path_589137, query_589138, nil, nil, nil)

var containeranalysisProjectsNotesList* = Call_ContaineranalysisProjectsNotesList_589116(
    name: "containeranalysisProjectsNotesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{parent}/notes",
    validator: validate_ContaineranalysisProjectsNotesList_589117, base: "/",
    url: url_ContaineranalysisProjectsNotesList_589118, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesCreate_589186 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsOccurrencesCreate_589188(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesCreate_589187(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Occurrence`. Use this method to create `Occurrences`
  ## for a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This field contains the project Id for example: "projects/{project_id}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589189 = path.getOrDefault("parent")
  valid_589189 = validateParameter(valid_589189, JString, required = true,
                                 default = nil)
  if valid_589189 != nil:
    section.add "parent", valid_589189
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
  ##   name: JString
  ##       : The name of the project.  Should be of the form "projects/{project_id}".
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589190 = query.getOrDefault("upload_protocol")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "upload_protocol", valid_589190
  var valid_589191 = query.getOrDefault("fields")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "fields", valid_589191
  var valid_589192 = query.getOrDefault("quotaUser")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "quotaUser", valid_589192
  var valid_589193 = query.getOrDefault("alt")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = newJString("json"))
  if valid_589193 != nil:
    section.add "alt", valid_589193
  var valid_589194 = query.getOrDefault("oauth_token")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "oauth_token", valid_589194
  var valid_589195 = query.getOrDefault("callback")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "callback", valid_589195
  var valid_589196 = query.getOrDefault("access_token")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "access_token", valid_589196
  var valid_589197 = query.getOrDefault("uploadType")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "uploadType", valid_589197
  var valid_589198 = query.getOrDefault("key")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "key", valid_589198
  var valid_589199 = query.getOrDefault("name")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "name", valid_589199
  var valid_589200 = query.getOrDefault("$.xgafv")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = newJString("1"))
  if valid_589200 != nil:
    section.add "$.xgafv", valid_589200
  var valid_589201 = query.getOrDefault("prettyPrint")
  valid_589201 = validateParameter(valid_589201, JBool, required = false,
                                 default = newJBool(true))
  if valid_589201 != nil:
    section.add "prettyPrint", valid_589201
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

proc call*(call_589203: Call_ContaineranalysisProjectsOccurrencesCreate_589186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Occurrence`. Use this method to create `Occurrences`
  ## for a resource.
  ## 
  let valid = call_589203.validator(path, query, header, formData, body)
  let scheme = call_589203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589203.url(scheme.get, call_589203.host, call_589203.base,
                         call_589203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589203, url, valid)

proc call*(call_589204: Call_ContaineranalysisProjectsOccurrencesCreate_589186;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsOccurrencesCreate
  ## Creates a new `Occurrence`. Use this method to create `Occurrences`
  ## for a resource.
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
  ##         : This field contains the project Id for example: "projects/{project_id}"
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name of the project.  Should be of the form "projects/{project_id}".
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589205 = newJObject()
  var query_589206 = newJObject()
  var body_589207 = newJObject()
  add(query_589206, "upload_protocol", newJString(uploadProtocol))
  add(query_589206, "fields", newJString(fields))
  add(query_589206, "quotaUser", newJString(quotaUser))
  add(query_589206, "alt", newJString(alt))
  add(query_589206, "oauth_token", newJString(oauthToken))
  add(query_589206, "callback", newJString(callback))
  add(query_589206, "access_token", newJString(accessToken))
  add(query_589206, "uploadType", newJString(uploadType))
  add(path_589205, "parent", newJString(parent))
  add(query_589206, "key", newJString(key))
  add(query_589206, "name", newJString(name))
  add(query_589206, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589207 = body
  add(query_589206, "prettyPrint", newJBool(prettyPrint))
  result = call_589204.call(path_589205, query_589206, nil, nil, body_589207)

var containeranalysisProjectsOccurrencesCreate* = Call_ContaineranalysisProjectsOccurrencesCreate_589186(
    name: "containeranalysisProjectsOccurrencesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/occurrences",
    validator: validate_ContaineranalysisProjectsOccurrencesCreate_589187,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesCreate_589188,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesList_589162 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsOccurrencesList_589164(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesList_589163(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists active `Occurrences` for a given project matching the filters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This contains the project Id for example: projects/{project_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589165 = path.getOrDefault("parent")
  valid_589165 = validateParameter(valid_589165, JString, required = true,
                                 default = nil)
  if valid_589165 != nil:
    section.add "parent", valid_589165
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##   kind: JString
  ##       : The kind of occurrences to filter on.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name field contains the project Id. For example:
  ## "projects/{project_id}
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of occurrences to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_589166 = query.getOrDefault("upload_protocol")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "upload_protocol", valid_589166
  var valid_589167 = query.getOrDefault("fields")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "fields", valid_589167
  var valid_589168 = query.getOrDefault("pageToken")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "pageToken", valid_589168
  var valid_589169 = query.getOrDefault("quotaUser")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "quotaUser", valid_589169
  var valid_589170 = query.getOrDefault("alt")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = newJString("json"))
  if valid_589170 != nil:
    section.add "alt", valid_589170
  var valid_589171 = query.getOrDefault("oauth_token")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "oauth_token", valid_589171
  var valid_589172 = query.getOrDefault("callback")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "callback", valid_589172
  var valid_589173 = query.getOrDefault("access_token")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "access_token", valid_589173
  var valid_589174 = query.getOrDefault("uploadType")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "uploadType", valid_589174
  var valid_589175 = query.getOrDefault("kind")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = newJString("KIND_UNSPECIFIED"))
  if valid_589175 != nil:
    section.add "kind", valid_589175
  var valid_589176 = query.getOrDefault("key")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "key", valid_589176
  var valid_589177 = query.getOrDefault("name")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "name", valid_589177
  var valid_589178 = query.getOrDefault("$.xgafv")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = newJString("1"))
  if valid_589178 != nil:
    section.add "$.xgafv", valid_589178
  var valid_589179 = query.getOrDefault("pageSize")
  valid_589179 = validateParameter(valid_589179, JInt, required = false, default = nil)
  if valid_589179 != nil:
    section.add "pageSize", valid_589179
  var valid_589180 = query.getOrDefault("prettyPrint")
  valid_589180 = validateParameter(valid_589180, JBool, required = false,
                                 default = newJBool(true))
  if valid_589180 != nil:
    section.add "prettyPrint", valid_589180
  var valid_589181 = query.getOrDefault("filter")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "filter", valid_589181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589182: Call_ContaineranalysisProjectsOccurrencesList_589162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists active `Occurrences` for a given project matching the filters.
  ## 
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_ContaineranalysisProjectsOccurrencesList_589162;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; kind: string = "KIND_UNSPECIFIED"; key: string = "";
          name: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesList
  ## Lists active `Occurrences` for a given project matching the filters.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##         : This contains the project Id for example: projects/{project_id}.
  ##   kind: string
  ##       : The kind of occurrences to filter on.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name field contains the project Id. For example:
  ## "projects/{project_id}
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of occurrences to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_589184 = newJObject()
  var query_589185 = newJObject()
  add(query_589185, "upload_protocol", newJString(uploadProtocol))
  add(query_589185, "fields", newJString(fields))
  add(query_589185, "pageToken", newJString(pageToken))
  add(query_589185, "quotaUser", newJString(quotaUser))
  add(query_589185, "alt", newJString(alt))
  add(query_589185, "oauth_token", newJString(oauthToken))
  add(query_589185, "callback", newJString(callback))
  add(query_589185, "access_token", newJString(accessToken))
  add(query_589185, "uploadType", newJString(uploadType))
  add(path_589184, "parent", newJString(parent))
  add(query_589185, "kind", newJString(kind))
  add(query_589185, "key", newJString(key))
  add(query_589185, "name", newJString(name))
  add(query_589185, "$.xgafv", newJString(Xgafv))
  add(query_589185, "pageSize", newJInt(pageSize))
  add(query_589185, "prettyPrint", newJBool(prettyPrint))
  add(query_589185, "filter", newJString(filter))
  result = call_589183.call(path_589184, query_589185, nil, nil, nil)

var containeranalysisProjectsOccurrencesList* = Call_ContaineranalysisProjectsOccurrencesList_589162(
    name: "containeranalysisProjectsOccurrencesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/occurrences",
    validator: validate_ContaineranalysisProjectsOccurrencesList_589163,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesList_589164,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589208 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589210(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"), (kind: ConstantSegment,
        value: "/occurrences:vulnerabilitySummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589209(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a summary of the number and severity of occurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This contains the project Id for example: projects/{project_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589211 = path.getOrDefault("parent")
  valid_589211 = validateParameter(valid_589211, JString, required = true,
                                 default = nil)
  if valid_589211 != nil:
    section.add "parent", valid_589211
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
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_589212 = query.getOrDefault("upload_protocol")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "upload_protocol", valid_589212
  var valid_589213 = query.getOrDefault("fields")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "fields", valid_589213
  var valid_589214 = query.getOrDefault("quotaUser")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "quotaUser", valid_589214
  var valid_589215 = query.getOrDefault("alt")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = newJString("json"))
  if valid_589215 != nil:
    section.add "alt", valid_589215
  var valid_589216 = query.getOrDefault("oauth_token")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "oauth_token", valid_589216
  var valid_589217 = query.getOrDefault("callback")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "callback", valid_589217
  var valid_589218 = query.getOrDefault("access_token")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "access_token", valid_589218
  var valid_589219 = query.getOrDefault("uploadType")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "uploadType", valid_589219
  var valid_589220 = query.getOrDefault("key")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "key", valid_589220
  var valid_589221 = query.getOrDefault("$.xgafv")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = newJString("1"))
  if valid_589221 != nil:
    section.add "$.xgafv", valid_589221
  var valid_589222 = query.getOrDefault("prettyPrint")
  valid_589222 = validateParameter(valid_589222, JBool, required = false,
                                 default = newJBool(true))
  if valid_589222 != nil:
    section.add "prettyPrint", valid_589222
  var valid_589223 = query.getOrDefault("filter")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "filter", valid_589223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589224: Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a summary of the number and severity of occurrences.
  ## 
  let valid = call_589224.validator(path, query, header, formData, body)
  let scheme = call_589224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589224.url(scheme.get, call_589224.host, call_589224.base,
                         call_589224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589224, url, valid)

proc call*(call_589225: Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589208;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesGetVulnerabilitySummary
  ## Gets a summary of the number and severity of occurrences.
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
  ##         : This contains the project Id for example: projects/{project_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_589226 = newJObject()
  var query_589227 = newJObject()
  add(query_589227, "upload_protocol", newJString(uploadProtocol))
  add(query_589227, "fields", newJString(fields))
  add(query_589227, "quotaUser", newJString(quotaUser))
  add(query_589227, "alt", newJString(alt))
  add(query_589227, "oauth_token", newJString(oauthToken))
  add(query_589227, "callback", newJString(callback))
  add(query_589227, "access_token", newJString(accessToken))
  add(query_589227, "uploadType", newJString(uploadType))
  add(path_589226, "parent", newJString(parent))
  add(query_589227, "key", newJString(key))
  add(query_589227, "$.xgafv", newJString(Xgafv))
  add(query_589227, "prettyPrint", newJBool(prettyPrint))
  add(query_589227, "filter", newJString(filter))
  result = call_589225.call(path_589226, query_589227, nil, nil, nil)

var containeranalysisProjectsOccurrencesGetVulnerabilitySummary* = Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589208(
    name: "containeranalysisProjectsOccurrencesGetVulnerabilitySummary",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/occurrences:vulnerabilitySummary", validator: validate_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589209,
    base: "/",
    url: url_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589210,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOperationsCreate_589228 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsOperationsCreate_589230(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOperationsCreate_589229(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Operation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project Id that this operation should be created under.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589231 = path.getOrDefault("parent")
  valid_589231 = validateParameter(valid_589231, JString, required = true,
                                 default = nil)
  if valid_589231 != nil:
    section.add "parent", valid_589231
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
  var valid_589232 = query.getOrDefault("upload_protocol")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "upload_protocol", valid_589232
  var valid_589233 = query.getOrDefault("fields")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "fields", valid_589233
  var valid_589234 = query.getOrDefault("quotaUser")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "quotaUser", valid_589234
  var valid_589235 = query.getOrDefault("alt")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("json"))
  if valid_589235 != nil:
    section.add "alt", valid_589235
  var valid_589236 = query.getOrDefault("oauth_token")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "oauth_token", valid_589236
  var valid_589237 = query.getOrDefault("callback")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "callback", valid_589237
  var valid_589238 = query.getOrDefault("access_token")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "access_token", valid_589238
  var valid_589239 = query.getOrDefault("uploadType")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "uploadType", valid_589239
  var valid_589240 = query.getOrDefault("key")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "key", valid_589240
  var valid_589241 = query.getOrDefault("$.xgafv")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = newJString("1"))
  if valid_589241 != nil:
    section.add "$.xgafv", valid_589241
  var valid_589242 = query.getOrDefault("prettyPrint")
  valid_589242 = validateParameter(valid_589242, JBool, required = false,
                                 default = newJBool(true))
  if valid_589242 != nil:
    section.add "prettyPrint", valid_589242
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

proc call*(call_589244: Call_ContaineranalysisProjectsOperationsCreate_589228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Operation`.
  ## 
  let valid = call_589244.validator(path, query, header, formData, body)
  let scheme = call_589244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589244.url(scheme.get, call_589244.host, call_589244.base,
                         call_589244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589244, url, valid)

proc call*(call_589245: Call_ContaineranalysisProjectsOperationsCreate_589228;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsOperationsCreate
  ## Creates a new `Operation`.
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
  ##         : The project Id that this operation should be created under.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589246 = newJObject()
  var query_589247 = newJObject()
  var body_589248 = newJObject()
  add(query_589247, "upload_protocol", newJString(uploadProtocol))
  add(query_589247, "fields", newJString(fields))
  add(query_589247, "quotaUser", newJString(quotaUser))
  add(query_589247, "alt", newJString(alt))
  add(query_589247, "oauth_token", newJString(oauthToken))
  add(query_589247, "callback", newJString(callback))
  add(query_589247, "access_token", newJString(accessToken))
  add(query_589247, "uploadType", newJString(uploadType))
  add(path_589246, "parent", newJString(parent))
  add(query_589247, "key", newJString(key))
  add(query_589247, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589248 = body
  add(query_589247, "prettyPrint", newJBool(prettyPrint))
  result = call_589245.call(path_589246, query_589247, nil, nil, body_589248)

var containeranalysisProjectsOperationsCreate* = Call_ContaineranalysisProjectsOperationsCreate_589228(
    name: "containeranalysisProjectsOperationsCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/operations",
    validator: validate_ContaineranalysisProjectsOperationsCreate_589229,
    base: "/", url: url_ContaineranalysisProjectsOperationsCreate_589230,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsScanConfigsList_589249 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsScanConfigsList_589251(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/scanConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsScanConfigsList_589250(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists scan configurations for a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This containers the project Id i.e.: projects/{project_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589252 = path.getOrDefault("parent")
  valid_589252 = validateParameter(valid_589252, JString, required = true,
                                 default = nil)
  if valid_589252 != nil:
    section.add "parent", valid_589252
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The page token to use for the next request.
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
  ##           : The number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_589253 = query.getOrDefault("upload_protocol")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "upload_protocol", valid_589253
  var valid_589254 = query.getOrDefault("fields")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "fields", valid_589254
  var valid_589255 = query.getOrDefault("pageToken")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "pageToken", valid_589255
  var valid_589256 = query.getOrDefault("quotaUser")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "quotaUser", valid_589256
  var valid_589257 = query.getOrDefault("alt")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = newJString("json"))
  if valid_589257 != nil:
    section.add "alt", valid_589257
  var valid_589258 = query.getOrDefault("oauth_token")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "oauth_token", valid_589258
  var valid_589259 = query.getOrDefault("callback")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "callback", valid_589259
  var valid_589260 = query.getOrDefault("access_token")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "access_token", valid_589260
  var valid_589261 = query.getOrDefault("uploadType")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "uploadType", valid_589261
  var valid_589262 = query.getOrDefault("key")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "key", valid_589262
  var valid_589263 = query.getOrDefault("$.xgafv")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = newJString("1"))
  if valid_589263 != nil:
    section.add "$.xgafv", valid_589263
  var valid_589264 = query.getOrDefault("pageSize")
  valid_589264 = validateParameter(valid_589264, JInt, required = false, default = nil)
  if valid_589264 != nil:
    section.add "pageSize", valid_589264
  var valid_589265 = query.getOrDefault("prettyPrint")
  valid_589265 = validateParameter(valid_589265, JBool, required = false,
                                 default = newJBool(true))
  if valid_589265 != nil:
    section.add "prettyPrint", valid_589265
  var valid_589266 = query.getOrDefault("filter")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "filter", valid_589266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589267: Call_ContaineranalysisProjectsScanConfigsList_589249;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists scan configurations for a project.
  ## 
  let valid = call_589267.validator(path, query, header, formData, body)
  let scheme = call_589267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589267.url(scheme.get, call_589267.host, call_589267.base,
                         call_589267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589267, url, valid)

proc call*(call_589268: Call_ContaineranalysisProjectsScanConfigsList_589249;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsScanConfigsList
  ## Lists scan configurations for a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The page token to use for the next request.
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
  ##         : This containers the project Id i.e.: projects/{project_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_589269 = newJObject()
  var query_589270 = newJObject()
  add(query_589270, "upload_protocol", newJString(uploadProtocol))
  add(query_589270, "fields", newJString(fields))
  add(query_589270, "pageToken", newJString(pageToken))
  add(query_589270, "quotaUser", newJString(quotaUser))
  add(query_589270, "alt", newJString(alt))
  add(query_589270, "oauth_token", newJString(oauthToken))
  add(query_589270, "callback", newJString(callback))
  add(query_589270, "access_token", newJString(accessToken))
  add(query_589270, "uploadType", newJString(uploadType))
  add(path_589269, "parent", newJString(parent))
  add(query_589270, "key", newJString(key))
  add(query_589270, "$.xgafv", newJString(Xgafv))
  add(query_589270, "pageSize", newJInt(pageSize))
  add(query_589270, "prettyPrint", newJBool(prettyPrint))
  add(query_589270, "filter", newJString(filter))
  result = call_589268.call(path_589269, query_589270, nil, nil, nil)

var containeranalysisProjectsScanConfigsList* = Call_ContaineranalysisProjectsScanConfigsList_589249(
    name: "containeranalysisProjectsScanConfigsList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/scanConfigs",
    validator: validate_ContaineranalysisProjectsScanConfigsList_589250,
    base: "/", url: url_ContaineranalysisProjectsScanConfigsList_589251,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesGetIamPolicy_589271 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProvidersNotesGetIamPolicy_589273(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesGetIamPolicy_589272(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a note or an `Occurrence` resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## Attempting to call this method on a resource without the required
  ## permission will result in a `PERMISSION_DENIED` error. Attempting to call
  ## this method on a non-existent resource will result in a `NOT_FOUND` error
  ## if the user has list permission on the project, or a `PERMISSION_DENIED`
  ## error otherwise. The resource takes the following formats:
  ## `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for occurrences and
  ## projects/{PROJECT_ID}/notes/{NOTE_ID} for notes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589274 = path.getOrDefault("resource")
  valid_589274 = validateParameter(valid_589274, JString, required = true,
                                 default = nil)
  if valid_589274 != nil:
    section.add "resource", valid_589274
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
  var valid_589275 = query.getOrDefault("upload_protocol")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "upload_protocol", valid_589275
  var valid_589276 = query.getOrDefault("fields")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "fields", valid_589276
  var valid_589277 = query.getOrDefault("quotaUser")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "quotaUser", valid_589277
  var valid_589278 = query.getOrDefault("alt")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = newJString("json"))
  if valid_589278 != nil:
    section.add "alt", valid_589278
  var valid_589279 = query.getOrDefault("oauth_token")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "oauth_token", valid_589279
  var valid_589280 = query.getOrDefault("callback")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "callback", valid_589280
  var valid_589281 = query.getOrDefault("access_token")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "access_token", valid_589281
  var valid_589282 = query.getOrDefault("uploadType")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "uploadType", valid_589282
  var valid_589283 = query.getOrDefault("key")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "key", valid_589283
  var valid_589284 = query.getOrDefault("$.xgafv")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = newJString("1"))
  if valid_589284 != nil:
    section.add "$.xgafv", valid_589284
  var valid_589285 = query.getOrDefault("prettyPrint")
  valid_589285 = validateParameter(valid_589285, JBool, required = false,
                                 default = newJBool(true))
  if valid_589285 != nil:
    section.add "prettyPrint", valid_589285
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

proc call*(call_589287: Call_ContaineranalysisProvidersNotesGetIamPolicy_589271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a note or an `Occurrence` resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## Attempting to call this method on a resource without the required
  ## permission will result in a `PERMISSION_DENIED` error. Attempting to call
  ## this method on a non-existent resource will result in a `NOT_FOUND` error
  ## if the user has list permission on the project, or a `PERMISSION_DENIED`
  ## error otherwise. The resource takes the following formats:
  ## `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for occurrences and
  ## projects/{PROJECT_ID}/notes/{NOTE_ID} for notes
  ## 
  let valid = call_589287.validator(path, query, header, formData, body)
  let scheme = call_589287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589287.url(scheme.get, call_589287.host, call_589287.base,
                         call_589287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589287, url, valid)

proc call*(call_589288: Call_ContaineranalysisProvidersNotesGetIamPolicy_589271;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProvidersNotesGetIamPolicy
  ## Gets the access control policy for a note or an `Occurrence` resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## Attempting to call this method on a resource without the required
  ## permission will result in a `PERMISSION_DENIED` error. Attempting to call
  ## this method on a non-existent resource will result in a `NOT_FOUND` error
  ## if the user has list permission on the project, or a `PERMISSION_DENIED`
  ## error otherwise. The resource takes the following formats:
  ## `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for occurrences and
  ## projects/{PROJECT_ID}/notes/{NOTE_ID} for notes
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589289 = newJObject()
  var query_589290 = newJObject()
  var body_589291 = newJObject()
  add(query_589290, "upload_protocol", newJString(uploadProtocol))
  add(query_589290, "fields", newJString(fields))
  add(query_589290, "quotaUser", newJString(quotaUser))
  add(query_589290, "alt", newJString(alt))
  add(query_589290, "oauth_token", newJString(oauthToken))
  add(query_589290, "callback", newJString(callback))
  add(query_589290, "access_token", newJString(accessToken))
  add(query_589290, "uploadType", newJString(uploadType))
  add(query_589290, "key", newJString(key))
  add(query_589290, "$.xgafv", newJString(Xgafv))
  add(path_589289, "resource", newJString(resource))
  if body != nil:
    body_589291 = body
  add(query_589290, "prettyPrint", newJBool(prettyPrint))
  result = call_589288.call(path_589289, query_589290, nil, nil, body_589291)

var containeranalysisProvidersNotesGetIamPolicy* = Call_ContaineranalysisProvidersNotesGetIamPolicy_589271(
    name: "containeranalysisProvidersNotesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_ContaineranalysisProvidersNotesGetIamPolicy_589272,
    base: "/", url: url_ContaineranalysisProvidersNotesGetIamPolicy_589273,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesSetIamPolicy_589292 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProvidersNotesSetIamPolicy_589294(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesSetIamPolicy_589293(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified `Note` or `Occurrence`.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a `Note` or an `Occurrence`, respectively.
  ## Attempting to call this method without these permissions will result in a `
  ## `PERMISSION_DENIED` error.
  ## Attempting to call this method on a non-existent resource will result in a
  ## `NOT_FOUND` error if the user has `containeranalysis.notes.list` permission
  ## on a `Note` or `containeranalysis.occurrences.list` on an `Occurrence`, or
  ## a `PERMISSION_DENIED` error otherwise. The resource takes the following
  ## formats: `projects/{projectid}/occurrences/{occurrenceid}` for occurrences
  ## and projects/{projectid}/notes/{noteid} for notes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589295 = path.getOrDefault("resource")
  valid_589295 = validateParameter(valid_589295, JString, required = true,
                                 default = nil)
  if valid_589295 != nil:
    section.add "resource", valid_589295
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
  var valid_589296 = query.getOrDefault("upload_protocol")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "upload_protocol", valid_589296
  var valid_589297 = query.getOrDefault("fields")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "fields", valid_589297
  var valid_589298 = query.getOrDefault("quotaUser")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "quotaUser", valid_589298
  var valid_589299 = query.getOrDefault("alt")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = newJString("json"))
  if valid_589299 != nil:
    section.add "alt", valid_589299
  var valid_589300 = query.getOrDefault("oauth_token")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "oauth_token", valid_589300
  var valid_589301 = query.getOrDefault("callback")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "callback", valid_589301
  var valid_589302 = query.getOrDefault("access_token")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "access_token", valid_589302
  var valid_589303 = query.getOrDefault("uploadType")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "uploadType", valid_589303
  var valid_589304 = query.getOrDefault("key")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "key", valid_589304
  var valid_589305 = query.getOrDefault("$.xgafv")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = newJString("1"))
  if valid_589305 != nil:
    section.add "$.xgafv", valid_589305
  var valid_589306 = query.getOrDefault("prettyPrint")
  valid_589306 = validateParameter(valid_589306, JBool, required = false,
                                 default = newJBool(true))
  if valid_589306 != nil:
    section.add "prettyPrint", valid_589306
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

proc call*(call_589308: Call_ContaineranalysisProvidersNotesSetIamPolicy_589292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified `Note` or `Occurrence`.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a `Note` or an `Occurrence`, respectively.
  ## Attempting to call this method without these permissions will result in a `
  ## `PERMISSION_DENIED` error.
  ## Attempting to call this method on a non-existent resource will result in a
  ## `NOT_FOUND` error if the user has `containeranalysis.notes.list` permission
  ## on a `Note` or `containeranalysis.occurrences.list` on an `Occurrence`, or
  ## a `PERMISSION_DENIED` error otherwise. The resource takes the following
  ## formats: `projects/{projectid}/occurrences/{occurrenceid}` for occurrences
  ## and projects/{projectid}/notes/{noteid} for notes
  ## 
  let valid = call_589308.validator(path, query, header, formData, body)
  let scheme = call_589308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589308.url(scheme.get, call_589308.host, call_589308.base,
                         call_589308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589308, url, valid)

proc call*(call_589309: Call_ContaineranalysisProvidersNotesSetIamPolicy_589292;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProvidersNotesSetIamPolicy
  ## Sets the access control policy on the specified `Note` or `Occurrence`.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a `Note` or an `Occurrence`, respectively.
  ## Attempting to call this method without these permissions will result in a `
  ## `PERMISSION_DENIED` error.
  ## Attempting to call this method on a non-existent resource will result in a
  ## `NOT_FOUND` error if the user has `containeranalysis.notes.list` permission
  ## on a `Note` or `containeranalysis.occurrences.list` on an `Occurrence`, or
  ## a `PERMISSION_DENIED` error otherwise. The resource takes the following
  ## formats: `projects/{projectid}/occurrences/{occurrenceid}` for occurrences
  ## and projects/{projectid}/notes/{noteid} for notes
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589310 = newJObject()
  var query_589311 = newJObject()
  var body_589312 = newJObject()
  add(query_589311, "upload_protocol", newJString(uploadProtocol))
  add(query_589311, "fields", newJString(fields))
  add(query_589311, "quotaUser", newJString(quotaUser))
  add(query_589311, "alt", newJString(alt))
  add(query_589311, "oauth_token", newJString(oauthToken))
  add(query_589311, "callback", newJString(callback))
  add(query_589311, "access_token", newJString(accessToken))
  add(query_589311, "uploadType", newJString(uploadType))
  add(query_589311, "key", newJString(key))
  add(query_589311, "$.xgafv", newJString(Xgafv))
  add(path_589310, "resource", newJString(resource))
  if body != nil:
    body_589312 = body
  add(query_589311, "prettyPrint", newJBool(prettyPrint))
  result = call_589309.call(path_589310, query_589311, nil, nil, body_589312)

var containeranalysisProvidersNotesSetIamPolicy* = Call_ContaineranalysisProvidersNotesSetIamPolicy_589292(
    name: "containeranalysisProvidersNotesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_ContaineranalysisProvidersNotesSetIamPolicy_589293,
    base: "/", url: url_ContaineranalysisProvidersNotesSetIamPolicy_589294,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesTestIamPermissions_589313 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProvidersNotesTestIamPermissions_589315(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesTestIamPermissions_589314(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence resource. Requires list permission on the project (for example,
  ## "storage.objects.list" on the containing bucket for testing permission of
  ## an object). Attempting to call this method on a non-existent resource will
  ## result in a `NOT_FOUND` error if the user has list permission on the
  ## project, or a `PERMISSION_DENIED` error otherwise. The resource takes the
  ## following formats: `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for
  ## `Occurrences` and `projects/{PROJECT_ID}/notes/{NOTE_ID}` for `Notes`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589316 = path.getOrDefault("resource")
  valid_589316 = validateParameter(valid_589316, JString, required = true,
                                 default = nil)
  if valid_589316 != nil:
    section.add "resource", valid_589316
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
  var valid_589317 = query.getOrDefault("upload_protocol")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "upload_protocol", valid_589317
  var valid_589318 = query.getOrDefault("fields")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "fields", valid_589318
  var valid_589319 = query.getOrDefault("quotaUser")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "quotaUser", valid_589319
  var valid_589320 = query.getOrDefault("alt")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = newJString("json"))
  if valid_589320 != nil:
    section.add "alt", valid_589320
  var valid_589321 = query.getOrDefault("oauth_token")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "oauth_token", valid_589321
  var valid_589322 = query.getOrDefault("callback")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "callback", valid_589322
  var valid_589323 = query.getOrDefault("access_token")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "access_token", valid_589323
  var valid_589324 = query.getOrDefault("uploadType")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "uploadType", valid_589324
  var valid_589325 = query.getOrDefault("key")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "key", valid_589325
  var valid_589326 = query.getOrDefault("$.xgafv")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = newJString("1"))
  if valid_589326 != nil:
    section.add "$.xgafv", valid_589326
  var valid_589327 = query.getOrDefault("prettyPrint")
  valid_589327 = validateParameter(valid_589327, JBool, required = false,
                                 default = newJBool(true))
  if valid_589327 != nil:
    section.add "prettyPrint", valid_589327
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

proc call*(call_589329: Call_ContaineranalysisProvidersNotesTestIamPermissions_589313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence resource. Requires list permission on the project (for example,
  ## "storage.objects.list" on the containing bucket for testing permission of
  ## an object). Attempting to call this method on a non-existent resource will
  ## result in a `NOT_FOUND` error if the user has list permission on the
  ## project, or a `PERMISSION_DENIED` error otherwise. The resource takes the
  ## following formats: `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for
  ## `Occurrences` and `projects/{PROJECT_ID}/notes/{NOTE_ID}` for `Notes`
  ## 
  let valid = call_589329.validator(path, query, header, formData, body)
  let scheme = call_589329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589329.url(scheme.get, call_589329.host, call_589329.base,
                         call_589329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589329, url, valid)

proc call*(call_589330: Call_ContaineranalysisProvidersNotesTestIamPermissions_589313;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProvidersNotesTestIamPermissions
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence resource. Requires list permission on the project (for example,
  ## "storage.objects.list" on the containing bucket for testing permission of
  ## an object). Attempting to call this method on a non-existent resource will
  ## result in a `NOT_FOUND` error if the user has list permission on the
  ## project, or a `PERMISSION_DENIED` error otherwise. The resource takes the
  ## following formats: `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for
  ## `Occurrences` and `projects/{PROJECT_ID}/notes/{NOTE_ID}` for `Notes`
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589331 = newJObject()
  var query_589332 = newJObject()
  var body_589333 = newJObject()
  add(query_589332, "upload_protocol", newJString(uploadProtocol))
  add(query_589332, "fields", newJString(fields))
  add(query_589332, "quotaUser", newJString(quotaUser))
  add(query_589332, "alt", newJString(alt))
  add(query_589332, "oauth_token", newJString(oauthToken))
  add(query_589332, "callback", newJString(callback))
  add(query_589332, "access_token", newJString(accessToken))
  add(query_589332, "uploadType", newJString(uploadType))
  add(query_589332, "key", newJString(key))
  add(query_589332, "$.xgafv", newJString(Xgafv))
  add(path_589331, "resource", newJString(resource))
  if body != nil:
    body_589333 = body
  add(query_589332, "prettyPrint", newJBool(prettyPrint))
  result = call_589330.call(path_589331, query_589332, nil, nil, body_589333)

var containeranalysisProvidersNotesTestIamPermissions* = Call_ContaineranalysisProvidersNotesTestIamPermissions_589313(
    name: "containeranalysisProvidersNotesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_ContaineranalysisProvidersNotesTestIamPermissions_589314,
    base: "/", url: url_ContaineranalysisProvidersNotesTestIamPermissions_589315,
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
