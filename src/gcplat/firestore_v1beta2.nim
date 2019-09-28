
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Firestore
## version: v1beta2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses the NoSQL document database built for automatic scaling, high performance, and ease of application development.
## 
## 
## https://cloud.google.com/firestore
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "firestore"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_579677 = ref object of OpenApiRestCall_579408
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_579679(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_579678(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a composite index.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : A name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}/indexes/{index_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579805 = path.getOrDefault("name")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "name", valid_579805
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
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("callback")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "callback", valid_579824
  var valid_579825 = query.getOrDefault("access_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "access_token", valid_579825
  var valid_579826 = query.getOrDefault("uploadType")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "uploadType", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(true))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579852: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a composite index.
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_579677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsIndexesGet
  ## Gets a composite index.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : A name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}/indexes/{index_id}`
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
  var path_579924 = newJObject()
  var query_579926 = newJObject()
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(path_579924, "name", newJString(name))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "uploadType", newJString(uploadType))
  add(query_579926, "key", newJString(key))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  result = call_579923.call(path_579924, query_579926, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsIndexesGet* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_579677(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesGet",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_579678,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_579679,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_579984 = ref object of OpenApiRestCall_579408
proc url_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_579986(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_579985(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates a field configuration. Currently, field updates apply only to
  ## single field index configuration. However, calls to
  ## FirestoreAdmin.UpdateField should provide a field mask to avoid
  ## changing any configuration that the caller isn't aware of. The field mask
  ## should be specified as: `{ paths: "index_config" }`.
  ## 
  ## This call returns a google.longrunning.Operation which may be used to
  ## track the status of the field update. The metadata for
  ## the operation will be the type FieldOperationMetadata.
  ## 
  ## To configure the default field settings for the database, use
  ## the special `Field` with resource name:
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/__default__/fields/*`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : A field name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}/fields/{field_path}`
  ## 
  ## A field path may be a simple field name, e.g. `address` or a path to fields
  ## within map_value , e.g. `address.city`,
  ## or a special field path. The only valid special field is `*`, which
  ## represents any field.
  ## 
  ## Field paths may be quoted using ` (backtick). The only character that needs
  ## to be escaped within a quoted field path is the backtick character itself,
  ## escaped using a backslash. Special characters in field paths that
  ## must be quoted include: `*`, `.`,
  ## ``` (backtick), `[`, `]`, as well as any ascii symbolic characters.
  ## 
  ## Examples:
  ## (Note: Comments here are written in markdown syntax, so there is an
  ##  additional layer of backticks to represent a code block)
  ## `\`address.city\`` represents a field named `address.city`, not the map key
  ## `city` in the field `address`.
  ## `\`*\`` represents a field named `*`, not any field.
  ## 
  ## A special `Field` contains the default indexing settings for all fields.
  ## This field's resource name is:
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/__default__/fields/*`
  ## Indexes defined on this `Field` will be applied to all fields which do not
  ## have their own `Field` index configuration.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579987 = path.getOrDefault("name")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "name", valid_579987
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
  ##             : A mask, relative to the field. If specified, only configuration specified
  ## by this field_mask will be updated in the field.
  section = newJObject()
  var valid_579988 = query.getOrDefault("upload_protocol")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "upload_protocol", valid_579988
  var valid_579989 = query.getOrDefault("fields")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "fields", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("callback")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "callback", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("$.xgafv")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("1"))
  if valid_579997 != nil:
    section.add "$.xgafv", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  var valid_579999 = query.getOrDefault("updateMask")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "updateMask", valid_579999
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

proc call*(call_580001: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_579984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a field configuration. Currently, field updates apply only to
  ## single field index configuration. However, calls to
  ## FirestoreAdmin.UpdateField should provide a field mask to avoid
  ## changing any configuration that the caller isn't aware of. The field mask
  ## should be specified as: `{ paths: "index_config" }`.
  ## 
  ## This call returns a google.longrunning.Operation which may be used to
  ## track the status of the field update. The metadata for
  ## the operation will be the type FieldOperationMetadata.
  ## 
  ## To configure the default field settings for the database, use
  ## the special `Field` with resource name:
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/__default__/fields/*`.
  ## 
  let valid = call_580001.validator(path, query, header, formData, body)
  let scheme = call_580001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580001.url(scheme.get, call_580001.host, call_580001.base,
                         call_580001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580001, url, valid)

proc call*(call_580002: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_579984;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsFieldsPatch
  ## Updates a field configuration. Currently, field updates apply only to
  ## single field index configuration. However, calls to
  ## FirestoreAdmin.UpdateField should provide a field mask to avoid
  ## changing any configuration that the caller isn't aware of. The field mask
  ## should be specified as: `{ paths: "index_config" }`.
  ## 
  ## This call returns a google.longrunning.Operation which may be used to
  ## track the status of the field update. The metadata for
  ## the operation will be the type FieldOperationMetadata.
  ## 
  ## To configure the default field settings for the database, use
  ## the special `Field` with resource name:
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/__default__/fields/*`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : A field name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}/fields/{field_path}`
  ## 
  ## A field path may be a simple field name, e.g. `address` or a path to fields
  ## within map_value , e.g. `address.city`,
  ## or a special field path. The only valid special field is `*`, which
  ## represents any field.
  ## 
  ## Field paths may be quoted using ` (backtick). The only character that needs
  ## to be escaped within a quoted field path is the backtick character itself,
  ## escaped using a backslash. Special characters in field paths that
  ## must be quoted include: `*`, `.`,
  ## ``` (backtick), `[`, `]`, as well as any ascii symbolic characters.
  ## 
  ## Examples:
  ## (Note: Comments here are written in markdown syntax, so there is an
  ##  additional layer of backticks to represent a code block)
  ## `\`address.city\`` represents a field named `address.city`, not the map key
  ## `city` in the field `address`.
  ## `\`*\`` represents a field named `*`, not any field.
  ## 
  ## A special `Field` contains the default indexing settings for all fields.
  ## This field's resource name is:
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/__default__/fields/*`
  ## Indexes defined on this `Field` will be applied to all fields which do not
  ## have their own `Field` index configuration.
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
  ##             : A mask, relative to the field. If specified, only configuration specified
  ## by this field_mask will be updated in the field.
  var path_580003 = newJObject()
  var query_580004 = newJObject()
  var body_580005 = newJObject()
  add(query_580004, "upload_protocol", newJString(uploadProtocol))
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(path_580003, "name", newJString(name))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "callback", newJString(callback))
  add(query_580004, "access_token", newJString(accessToken))
  add(query_580004, "uploadType", newJString(uploadType))
  add(query_580004, "key", newJString(key))
  add(query_580004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580005 = body
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  add(query_580004, "updateMask", newJString(updateMask))
  result = call_580002.call(path_580003, query_580004, nil, nil, body_580005)

var firestoreProjectsDatabasesCollectionGroupsFieldsPatch* = Call_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_579984(
    name: "firestoreProjectsDatabasesCollectionGroupsFieldsPatch",
    meth: HttpMethod.HttpPatch, host: "firestore.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_579985,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_579986,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_579965 = ref object of OpenApiRestCall_579408
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_579967(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_579966(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a composite index.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : A name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}/indexes/{index_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579968 = path.getOrDefault("name")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "name", valid_579968
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
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("$.xgafv")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("1"))
  if valid_579978 != nil:
    section.add "$.xgafv", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579980: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_579965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a composite index.
  ## 
  let valid = call_579980.validator(path, query, header, formData, body)
  let scheme = call_579980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579980.url(scheme.get, call_579980.host, call_579980.base,
                         call_579980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579980, url, valid)

proc call*(call_579981: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_579965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsIndexesDelete
  ## Deletes a composite index.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : A name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}/indexes/{index_id}`
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
  var path_579982 = newJObject()
  var query_579983 = newJObject()
  add(query_579983, "upload_protocol", newJString(uploadProtocol))
  add(query_579983, "fields", newJString(fields))
  add(query_579983, "quotaUser", newJString(quotaUser))
  add(path_579982, "name", newJString(name))
  add(query_579983, "alt", newJString(alt))
  add(query_579983, "oauth_token", newJString(oauthToken))
  add(query_579983, "callback", newJString(callback))
  add(query_579983, "access_token", newJString(accessToken))
  add(query_579983, "uploadType", newJString(uploadType))
  add(query_579983, "key", newJString(key))
  add(query_579983, "$.xgafv", newJString(Xgafv))
  add(query_579983, "prettyPrint", newJBool(prettyPrint))
  result = call_579981.call(path_579982, query_579983, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsIndexesDelete* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_579965(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesDelete",
    meth: HttpMethod.HttpDelete, host: "firestore.googleapis.com",
    route: "/v1beta2/{name}", validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_579966,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_579967,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesExportDocuments_580006 = ref object of OpenApiRestCall_579408
proc url_FirestoreProjectsDatabasesExportDocuments_580008(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":exportDocuments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesExportDocuments_580007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports a copy of all or a subset of documents from Google Cloud Firestore
  ## to another storage system, such as Google Cloud Storage. Recent updates to
  ## documents may not be reflected in the export. The export occurs in the
  ## background and its progress can be monitored and managed via the
  ## Operation resource that is created. The output of an export may only be
  ## used once the associated operation is done. If an export operation is
  ## cancelled before completion it may leave partial data behind in Google
  ## Cloud Storage.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Database to export. Should be of the form:
  ## `projects/{project_id}/databases/{database_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580009 = path.getOrDefault("name")
  valid_580009 = validateParameter(valid_580009, JString, required = true,
                                 default = nil)
  if valid_580009 != nil:
    section.add "name", valid_580009
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
  var valid_580010 = query.getOrDefault("upload_protocol")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "upload_protocol", valid_580010
  var valid_580011 = query.getOrDefault("fields")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "fields", valid_580011
  var valid_580012 = query.getOrDefault("quotaUser")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "quotaUser", valid_580012
  var valid_580013 = query.getOrDefault("alt")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("json"))
  if valid_580013 != nil:
    section.add "alt", valid_580013
  var valid_580014 = query.getOrDefault("oauth_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "oauth_token", valid_580014
  var valid_580015 = query.getOrDefault("callback")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "callback", valid_580015
  var valid_580016 = query.getOrDefault("access_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "access_token", valid_580016
  var valid_580017 = query.getOrDefault("uploadType")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "uploadType", valid_580017
  var valid_580018 = query.getOrDefault("key")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "key", valid_580018
  var valid_580019 = query.getOrDefault("$.xgafv")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("1"))
  if valid_580019 != nil:
    section.add "$.xgafv", valid_580019
  var valid_580020 = query.getOrDefault("prettyPrint")
  valid_580020 = validateParameter(valid_580020, JBool, required = false,
                                 default = newJBool(true))
  if valid_580020 != nil:
    section.add "prettyPrint", valid_580020
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

proc call*(call_580022: Call_FirestoreProjectsDatabasesExportDocuments_580006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports a copy of all or a subset of documents from Google Cloud Firestore
  ## to another storage system, such as Google Cloud Storage. Recent updates to
  ## documents may not be reflected in the export. The export occurs in the
  ## background and its progress can be monitored and managed via the
  ## Operation resource that is created. The output of an export may only be
  ## used once the associated operation is done. If an export operation is
  ## cancelled before completion it may leave partial data behind in Google
  ## Cloud Storage.
  ## 
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_FirestoreProjectsDatabasesExportDocuments_580006;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesExportDocuments
  ## Exports a copy of all or a subset of documents from Google Cloud Firestore
  ## to another storage system, such as Google Cloud Storage. Recent updates to
  ## documents may not be reflected in the export. The export occurs in the
  ## background and its progress can be monitored and managed via the
  ## Operation resource that is created. The output of an export may only be
  ## used once the associated operation is done. If an export operation is
  ## cancelled before completion it may leave partial data behind in Google
  ## Cloud Storage.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Database to export. Should be of the form:
  ## `projects/{project_id}/databases/{database_id}`.
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
  var path_580024 = newJObject()
  var query_580025 = newJObject()
  var body_580026 = newJObject()
  add(query_580025, "upload_protocol", newJString(uploadProtocol))
  add(query_580025, "fields", newJString(fields))
  add(query_580025, "quotaUser", newJString(quotaUser))
  add(path_580024, "name", newJString(name))
  add(query_580025, "alt", newJString(alt))
  add(query_580025, "oauth_token", newJString(oauthToken))
  add(query_580025, "callback", newJString(callback))
  add(query_580025, "access_token", newJString(accessToken))
  add(query_580025, "uploadType", newJString(uploadType))
  add(query_580025, "key", newJString(key))
  add(query_580025, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580026 = body
  add(query_580025, "prettyPrint", newJBool(prettyPrint))
  result = call_580023.call(path_580024, query_580025, nil, nil, body_580026)

var firestoreProjectsDatabasesExportDocuments* = Call_FirestoreProjectsDatabasesExportDocuments_580006(
    name: "firestoreProjectsDatabasesExportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta2/{name}:exportDocuments",
    validator: validate_FirestoreProjectsDatabasesExportDocuments_580007,
    base: "/", url: url_FirestoreProjectsDatabasesExportDocuments_580008,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesImportDocuments_580027 = ref object of OpenApiRestCall_579408
proc url_FirestoreProjectsDatabasesImportDocuments_580029(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":importDocuments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesImportDocuments_580028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Database to import into. Should be of the form:
  ## `projects/{project_id}/databases/{database_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580030 = path.getOrDefault("name")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = nil)
  if valid_580030 != nil:
    section.add "name", valid_580030
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
  var valid_580031 = query.getOrDefault("upload_protocol")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "upload_protocol", valid_580031
  var valid_580032 = query.getOrDefault("fields")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "fields", valid_580032
  var valid_580033 = query.getOrDefault("quotaUser")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "quotaUser", valid_580033
  var valid_580034 = query.getOrDefault("alt")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("json"))
  if valid_580034 != nil:
    section.add "alt", valid_580034
  var valid_580035 = query.getOrDefault("oauth_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "oauth_token", valid_580035
  var valid_580036 = query.getOrDefault("callback")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "callback", valid_580036
  var valid_580037 = query.getOrDefault("access_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "access_token", valid_580037
  var valid_580038 = query.getOrDefault("uploadType")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "uploadType", valid_580038
  var valid_580039 = query.getOrDefault("key")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "key", valid_580039
  var valid_580040 = query.getOrDefault("$.xgafv")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = newJString("1"))
  if valid_580040 != nil:
    section.add "$.xgafv", valid_580040
  var valid_580041 = query.getOrDefault("prettyPrint")
  valid_580041 = validateParameter(valid_580041, JBool, required = false,
                                 default = newJBool(true))
  if valid_580041 != nil:
    section.add "prettyPrint", valid_580041
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

proc call*(call_580043: Call_FirestoreProjectsDatabasesImportDocuments_580027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
  ## 
  let valid = call_580043.validator(path, query, header, formData, body)
  let scheme = call_580043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580043.url(scheme.get, call_580043.host, call_580043.base,
                         call_580043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580043, url, valid)

proc call*(call_580044: Call_FirestoreProjectsDatabasesImportDocuments_580027;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesImportDocuments
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Database to import into. Should be of the form:
  ## `projects/{project_id}/databases/{database_id}`.
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
  var path_580045 = newJObject()
  var query_580046 = newJObject()
  var body_580047 = newJObject()
  add(query_580046, "upload_protocol", newJString(uploadProtocol))
  add(query_580046, "fields", newJString(fields))
  add(query_580046, "quotaUser", newJString(quotaUser))
  add(path_580045, "name", newJString(name))
  add(query_580046, "alt", newJString(alt))
  add(query_580046, "oauth_token", newJString(oauthToken))
  add(query_580046, "callback", newJString(callback))
  add(query_580046, "access_token", newJString(accessToken))
  add(query_580046, "uploadType", newJString(uploadType))
  add(query_580046, "key", newJString(key))
  add(query_580046, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580047 = body
  add(query_580046, "prettyPrint", newJBool(prettyPrint))
  result = call_580044.call(path_580045, query_580046, nil, nil, body_580047)

var firestoreProjectsDatabasesImportDocuments* = Call_FirestoreProjectsDatabasesImportDocuments_580027(
    name: "firestoreProjectsDatabasesImportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta2/{name}:importDocuments",
    validator: validate_FirestoreProjectsDatabasesImportDocuments_580028,
    base: "/", url: url_FirestoreProjectsDatabasesImportDocuments_580029,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_580048 = ref object of OpenApiRestCall_579408
proc url_FirestoreProjectsDatabasesCollectionGroupsFieldsList_580050(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fields")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesCollectionGroupsFieldsList_580049(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the field configuration and metadata for this database.
  ## 
  ## Currently, FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580051 = path.getOrDefault("parent")
  valid_580051 = validateParameter(valid_580051, JString, required = true,
                                 default = nil)
  if valid_580051 != nil:
    section.add "parent", valid_580051
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListFields, that may be used to get the next
  ## page of results.
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
  ##           : The number of results to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter to apply to list results. Currently,
  ## FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  section = newJObject()
  var valid_580052 = query.getOrDefault("upload_protocol")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "upload_protocol", valid_580052
  var valid_580053 = query.getOrDefault("fields")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "fields", valid_580053
  var valid_580054 = query.getOrDefault("pageToken")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "pageToken", valid_580054
  var valid_580055 = query.getOrDefault("quotaUser")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "quotaUser", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("oauth_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "oauth_token", valid_580057
  var valid_580058 = query.getOrDefault("callback")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "callback", valid_580058
  var valid_580059 = query.getOrDefault("access_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "access_token", valid_580059
  var valid_580060 = query.getOrDefault("uploadType")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "uploadType", valid_580060
  var valid_580061 = query.getOrDefault("key")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "key", valid_580061
  var valid_580062 = query.getOrDefault("$.xgafv")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("1"))
  if valid_580062 != nil:
    section.add "$.xgafv", valid_580062
  var valid_580063 = query.getOrDefault("pageSize")
  valid_580063 = validateParameter(valid_580063, JInt, required = false, default = nil)
  if valid_580063 != nil:
    section.add "pageSize", valid_580063
  var valid_580064 = query.getOrDefault("prettyPrint")
  valid_580064 = validateParameter(valid_580064, JBool, required = false,
                                 default = newJBool(true))
  if valid_580064 != nil:
    section.add "prettyPrint", valid_580064
  var valid_580065 = query.getOrDefault("filter")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "filter", valid_580065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_580048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the field configuration and metadata for this database.
  ## 
  ## Currently, FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_580048;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsFieldsList
  ## Lists the field configuration and metadata for this database.
  ## 
  ## Currently, FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListFields, that may be used to get the next
  ## page of results.
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
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of results to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter to apply to list results. Currently,
  ## FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  add(query_580069, "upload_protocol", newJString(uploadProtocol))
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "pageToken", newJString(pageToken))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "callback", newJString(callback))
  add(query_580069, "access_token", newJString(accessToken))
  add(query_580069, "uploadType", newJString(uploadType))
  add(path_580068, "parent", newJString(parent))
  add(query_580069, "key", newJString(key))
  add(query_580069, "$.xgafv", newJString(Xgafv))
  add(query_580069, "pageSize", newJInt(pageSize))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  add(query_580069, "filter", newJString(filter))
  result = call_580067.call(path_580068, query_580069, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsFieldsList* = Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_580048(
    name: "firestoreProjectsDatabasesCollectionGroupsFieldsList",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1beta2/{parent}/fields",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsFieldsList_580049,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsFieldsList_580050,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_580092 = ref object of OpenApiRestCall_579408
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_580094(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/indexes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_580093(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a composite index. This returns a google.longrunning.Operation
  ## which may be used to track the status of the creation. The metadata for
  ## the operation will be the type IndexOperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580095 = path.getOrDefault("parent")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "parent", valid_580095
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
  var valid_580096 = query.getOrDefault("upload_protocol")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "upload_protocol", valid_580096
  var valid_580097 = query.getOrDefault("fields")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "fields", valid_580097
  var valid_580098 = query.getOrDefault("quotaUser")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "quotaUser", valid_580098
  var valid_580099 = query.getOrDefault("alt")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("json"))
  if valid_580099 != nil:
    section.add "alt", valid_580099
  var valid_580100 = query.getOrDefault("oauth_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "oauth_token", valid_580100
  var valid_580101 = query.getOrDefault("callback")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "callback", valid_580101
  var valid_580102 = query.getOrDefault("access_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "access_token", valid_580102
  var valid_580103 = query.getOrDefault("uploadType")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "uploadType", valid_580103
  var valid_580104 = query.getOrDefault("key")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "key", valid_580104
  var valid_580105 = query.getOrDefault("$.xgafv")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = newJString("1"))
  if valid_580105 != nil:
    section.add "$.xgafv", valid_580105
  var valid_580106 = query.getOrDefault("prettyPrint")
  valid_580106 = validateParameter(valid_580106, JBool, required = false,
                                 default = newJBool(true))
  if valid_580106 != nil:
    section.add "prettyPrint", valid_580106
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

proc call*(call_580108: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_580092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a composite index. This returns a google.longrunning.Operation
  ## which may be used to track the status of the creation. The metadata for
  ## the operation will be the type IndexOperationMetadata.
  ## 
  let valid = call_580108.validator(path, query, header, formData, body)
  let scheme = call_580108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580108.url(scheme.get, call_580108.host, call_580108.base,
                         call_580108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580108, url, valid)

proc call*(call_580109: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_580092;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsIndexesCreate
  ## Creates a composite index. This returns a google.longrunning.Operation
  ## which may be used to track the status of the creation. The metadata for
  ## the operation will be the type IndexOperationMetadata.
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
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580110 = newJObject()
  var query_580111 = newJObject()
  var body_580112 = newJObject()
  add(query_580111, "upload_protocol", newJString(uploadProtocol))
  add(query_580111, "fields", newJString(fields))
  add(query_580111, "quotaUser", newJString(quotaUser))
  add(query_580111, "alt", newJString(alt))
  add(query_580111, "oauth_token", newJString(oauthToken))
  add(query_580111, "callback", newJString(callback))
  add(query_580111, "access_token", newJString(accessToken))
  add(query_580111, "uploadType", newJString(uploadType))
  add(path_580110, "parent", newJString(parent))
  add(query_580111, "key", newJString(key))
  add(query_580111, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580112 = body
  add(query_580111, "prettyPrint", newJBool(prettyPrint))
  result = call_580109.call(path_580110, query_580111, nil, nil, body_580112)

var firestoreProjectsDatabasesCollectionGroupsIndexesCreate* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_580092(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesCreate",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta2/{parent}/indexes", validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_580093,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_580094,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_580070 = ref object of OpenApiRestCall_579408
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesList_580072(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/indexes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesList_580071(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists composite indexes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580073 = path.getOrDefault("parent")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "parent", valid_580073
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListIndexes, that may be used to get the next
  ## page of results.
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
  ##           : The number of results to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter to apply to list results.
  section = newJObject()
  var valid_580074 = query.getOrDefault("upload_protocol")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "upload_protocol", valid_580074
  var valid_580075 = query.getOrDefault("fields")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "fields", valid_580075
  var valid_580076 = query.getOrDefault("pageToken")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "pageToken", valid_580076
  var valid_580077 = query.getOrDefault("quotaUser")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "quotaUser", valid_580077
  var valid_580078 = query.getOrDefault("alt")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("json"))
  if valid_580078 != nil:
    section.add "alt", valid_580078
  var valid_580079 = query.getOrDefault("oauth_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "oauth_token", valid_580079
  var valid_580080 = query.getOrDefault("callback")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "callback", valid_580080
  var valid_580081 = query.getOrDefault("access_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "access_token", valid_580081
  var valid_580082 = query.getOrDefault("uploadType")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "uploadType", valid_580082
  var valid_580083 = query.getOrDefault("key")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "key", valid_580083
  var valid_580084 = query.getOrDefault("$.xgafv")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("1"))
  if valid_580084 != nil:
    section.add "$.xgafv", valid_580084
  var valid_580085 = query.getOrDefault("pageSize")
  valid_580085 = validateParameter(valid_580085, JInt, required = false, default = nil)
  if valid_580085 != nil:
    section.add "pageSize", valid_580085
  var valid_580086 = query.getOrDefault("prettyPrint")
  valid_580086 = validateParameter(valid_580086, JBool, required = false,
                                 default = newJBool(true))
  if valid_580086 != nil:
    section.add "prettyPrint", valid_580086
  var valid_580087 = query.getOrDefault("filter")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "filter", valid_580087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580088: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_580070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists composite indexes.
  ## 
  let valid = call_580088.validator(path, query, header, formData, body)
  let scheme = call_580088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580088.url(scheme.get, call_580088.host, call_580088.base,
                         call_580088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580088, url, valid)

proc call*(call_580089: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_580070;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsIndexesList
  ## Lists composite indexes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListIndexes, that may be used to get the next
  ## page of results.
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
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of results to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter to apply to list results.
  var path_580090 = newJObject()
  var query_580091 = newJObject()
  add(query_580091, "upload_protocol", newJString(uploadProtocol))
  add(query_580091, "fields", newJString(fields))
  add(query_580091, "pageToken", newJString(pageToken))
  add(query_580091, "quotaUser", newJString(quotaUser))
  add(query_580091, "alt", newJString(alt))
  add(query_580091, "oauth_token", newJString(oauthToken))
  add(query_580091, "callback", newJString(callback))
  add(query_580091, "access_token", newJString(accessToken))
  add(query_580091, "uploadType", newJString(uploadType))
  add(path_580090, "parent", newJString(parent))
  add(query_580091, "key", newJString(key))
  add(query_580091, "$.xgafv", newJString(Xgafv))
  add(query_580091, "pageSize", newJInt(pageSize))
  add(query_580091, "prettyPrint", newJBool(prettyPrint))
  add(query_580091, "filter", newJString(filter))
  result = call_580089.call(path_580090, query_580091, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsIndexesList* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_580070(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesList",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1beta2/{parent}/indexes",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesList_580071,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesList_580072,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
