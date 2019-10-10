
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
  gcpServiceName = "firestore"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_588710 = ref object of OpenApiRestCall_588441
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_588712(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_588711(
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
  var valid_588838 = path.getOrDefault("name")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "name", valid_588838
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
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("prettyPrint")
  valid_588862 = validateParameter(valid_588862, JBool, required = false,
                                 default = newJBool(true))
  if valid_588862 != nil:
    section.add "prettyPrint", valid_588862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588885: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a composite index.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_588710;
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
  var path_588957 = newJObject()
  var query_588959 = newJObject()
  add(query_588959, "upload_protocol", newJString(uploadProtocol))
  add(query_588959, "fields", newJString(fields))
  add(query_588959, "quotaUser", newJString(quotaUser))
  add(path_588957, "name", newJString(name))
  add(query_588959, "alt", newJString(alt))
  add(query_588959, "oauth_token", newJString(oauthToken))
  add(query_588959, "callback", newJString(callback))
  add(query_588959, "access_token", newJString(accessToken))
  add(query_588959, "uploadType", newJString(uploadType))
  add(query_588959, "key", newJString(key))
  add(query_588959, "$.xgafv", newJString(Xgafv))
  add(query_588959, "prettyPrint", newJBool(prettyPrint))
  result = call_588956.call(path_588957, query_588959, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsIndexesGet* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_588710(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesGet",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_588711,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_588712,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_589017 = ref object of OpenApiRestCall_588441
proc url_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_589019(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_589018(
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
  var valid_589020 = path.getOrDefault("name")
  valid_589020 = validateParameter(valid_589020, JString, required = true,
                                 default = nil)
  if valid_589020 != nil:
    section.add "name", valid_589020
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
  var valid_589021 = query.getOrDefault("upload_protocol")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "upload_protocol", valid_589021
  var valid_589022 = query.getOrDefault("fields")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "fields", valid_589022
  var valid_589023 = query.getOrDefault("quotaUser")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "quotaUser", valid_589023
  var valid_589024 = query.getOrDefault("alt")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = newJString("json"))
  if valid_589024 != nil:
    section.add "alt", valid_589024
  var valid_589025 = query.getOrDefault("oauth_token")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "oauth_token", valid_589025
  var valid_589026 = query.getOrDefault("callback")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "callback", valid_589026
  var valid_589027 = query.getOrDefault("access_token")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "access_token", valid_589027
  var valid_589028 = query.getOrDefault("uploadType")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "uploadType", valid_589028
  var valid_589029 = query.getOrDefault("key")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "key", valid_589029
  var valid_589030 = query.getOrDefault("$.xgafv")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = newJString("1"))
  if valid_589030 != nil:
    section.add "$.xgafv", valid_589030
  var valid_589031 = query.getOrDefault("prettyPrint")
  valid_589031 = validateParameter(valid_589031, JBool, required = false,
                                 default = newJBool(true))
  if valid_589031 != nil:
    section.add "prettyPrint", valid_589031
  var valid_589032 = query.getOrDefault("updateMask")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "updateMask", valid_589032
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

proc call*(call_589034: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_589017;
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
  let valid = call_589034.validator(path, query, header, formData, body)
  let scheme = call_589034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589034.url(scheme.get, call_589034.host, call_589034.base,
                         call_589034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589034, url, valid)

proc call*(call_589035: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_589017;
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
  var path_589036 = newJObject()
  var query_589037 = newJObject()
  var body_589038 = newJObject()
  add(query_589037, "upload_protocol", newJString(uploadProtocol))
  add(query_589037, "fields", newJString(fields))
  add(query_589037, "quotaUser", newJString(quotaUser))
  add(path_589036, "name", newJString(name))
  add(query_589037, "alt", newJString(alt))
  add(query_589037, "oauth_token", newJString(oauthToken))
  add(query_589037, "callback", newJString(callback))
  add(query_589037, "access_token", newJString(accessToken))
  add(query_589037, "uploadType", newJString(uploadType))
  add(query_589037, "key", newJString(key))
  add(query_589037, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589038 = body
  add(query_589037, "prettyPrint", newJBool(prettyPrint))
  add(query_589037, "updateMask", newJString(updateMask))
  result = call_589035.call(path_589036, query_589037, nil, nil, body_589038)

var firestoreProjectsDatabasesCollectionGroupsFieldsPatch* = Call_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_589017(
    name: "firestoreProjectsDatabasesCollectionGroupsFieldsPatch",
    meth: HttpMethod.HttpPatch, host: "firestore.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_589018,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_589019,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_588998 = ref object of OpenApiRestCall_588441
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_589000(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_588999(
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
  var valid_589001 = path.getOrDefault("name")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "name", valid_589001
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
  var valid_589002 = query.getOrDefault("upload_protocol")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "upload_protocol", valid_589002
  var valid_589003 = query.getOrDefault("fields")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "fields", valid_589003
  var valid_589004 = query.getOrDefault("quotaUser")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "quotaUser", valid_589004
  var valid_589005 = query.getOrDefault("alt")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("json"))
  if valid_589005 != nil:
    section.add "alt", valid_589005
  var valid_589006 = query.getOrDefault("oauth_token")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "oauth_token", valid_589006
  var valid_589007 = query.getOrDefault("callback")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "callback", valid_589007
  var valid_589008 = query.getOrDefault("access_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "access_token", valid_589008
  var valid_589009 = query.getOrDefault("uploadType")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "uploadType", valid_589009
  var valid_589010 = query.getOrDefault("key")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "key", valid_589010
  var valid_589011 = query.getOrDefault("$.xgafv")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("1"))
  if valid_589011 != nil:
    section.add "$.xgafv", valid_589011
  var valid_589012 = query.getOrDefault("prettyPrint")
  valid_589012 = validateParameter(valid_589012, JBool, required = false,
                                 default = newJBool(true))
  if valid_589012 != nil:
    section.add "prettyPrint", valid_589012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589013: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_588998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a composite index.
  ## 
  let valid = call_589013.validator(path, query, header, formData, body)
  let scheme = call_589013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589013.url(scheme.get, call_589013.host, call_589013.base,
                         call_589013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589013, url, valid)

proc call*(call_589014: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_588998;
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
  var path_589015 = newJObject()
  var query_589016 = newJObject()
  add(query_589016, "upload_protocol", newJString(uploadProtocol))
  add(query_589016, "fields", newJString(fields))
  add(query_589016, "quotaUser", newJString(quotaUser))
  add(path_589015, "name", newJString(name))
  add(query_589016, "alt", newJString(alt))
  add(query_589016, "oauth_token", newJString(oauthToken))
  add(query_589016, "callback", newJString(callback))
  add(query_589016, "access_token", newJString(accessToken))
  add(query_589016, "uploadType", newJString(uploadType))
  add(query_589016, "key", newJString(key))
  add(query_589016, "$.xgafv", newJString(Xgafv))
  add(query_589016, "prettyPrint", newJBool(prettyPrint))
  result = call_589014.call(path_589015, query_589016, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsIndexesDelete* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_588998(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesDelete",
    meth: HttpMethod.HttpDelete, host: "firestore.googleapis.com",
    route: "/v1beta2/{name}", validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_588999,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_589000,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesExportDocuments_589039 = ref object of OpenApiRestCall_588441
proc url_FirestoreProjectsDatabasesExportDocuments_589041(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesExportDocuments_589040(path: JsonNode;
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
  var valid_589042 = path.getOrDefault("name")
  valid_589042 = validateParameter(valid_589042, JString, required = true,
                                 default = nil)
  if valid_589042 != nil:
    section.add "name", valid_589042
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
  var valid_589043 = query.getOrDefault("upload_protocol")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "upload_protocol", valid_589043
  var valid_589044 = query.getOrDefault("fields")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "fields", valid_589044
  var valid_589045 = query.getOrDefault("quotaUser")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "quotaUser", valid_589045
  var valid_589046 = query.getOrDefault("alt")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = newJString("json"))
  if valid_589046 != nil:
    section.add "alt", valid_589046
  var valid_589047 = query.getOrDefault("oauth_token")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "oauth_token", valid_589047
  var valid_589048 = query.getOrDefault("callback")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "callback", valid_589048
  var valid_589049 = query.getOrDefault("access_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "access_token", valid_589049
  var valid_589050 = query.getOrDefault("uploadType")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "uploadType", valid_589050
  var valid_589051 = query.getOrDefault("key")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "key", valid_589051
  var valid_589052 = query.getOrDefault("$.xgafv")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = newJString("1"))
  if valid_589052 != nil:
    section.add "$.xgafv", valid_589052
  var valid_589053 = query.getOrDefault("prettyPrint")
  valid_589053 = validateParameter(valid_589053, JBool, required = false,
                                 default = newJBool(true))
  if valid_589053 != nil:
    section.add "prettyPrint", valid_589053
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

proc call*(call_589055: Call_FirestoreProjectsDatabasesExportDocuments_589039;
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
  let valid = call_589055.validator(path, query, header, formData, body)
  let scheme = call_589055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589055.url(scheme.get, call_589055.host, call_589055.base,
                         call_589055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589055, url, valid)

proc call*(call_589056: Call_FirestoreProjectsDatabasesExportDocuments_589039;
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
  var path_589057 = newJObject()
  var query_589058 = newJObject()
  var body_589059 = newJObject()
  add(query_589058, "upload_protocol", newJString(uploadProtocol))
  add(query_589058, "fields", newJString(fields))
  add(query_589058, "quotaUser", newJString(quotaUser))
  add(path_589057, "name", newJString(name))
  add(query_589058, "alt", newJString(alt))
  add(query_589058, "oauth_token", newJString(oauthToken))
  add(query_589058, "callback", newJString(callback))
  add(query_589058, "access_token", newJString(accessToken))
  add(query_589058, "uploadType", newJString(uploadType))
  add(query_589058, "key", newJString(key))
  add(query_589058, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589059 = body
  add(query_589058, "prettyPrint", newJBool(prettyPrint))
  result = call_589056.call(path_589057, query_589058, nil, nil, body_589059)

var firestoreProjectsDatabasesExportDocuments* = Call_FirestoreProjectsDatabasesExportDocuments_589039(
    name: "firestoreProjectsDatabasesExportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta2/{name}:exportDocuments",
    validator: validate_FirestoreProjectsDatabasesExportDocuments_589040,
    base: "/", url: url_FirestoreProjectsDatabasesExportDocuments_589041,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesImportDocuments_589060 = ref object of OpenApiRestCall_588441
proc url_FirestoreProjectsDatabasesImportDocuments_589062(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesImportDocuments_589061(path: JsonNode;
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
  var valid_589063 = path.getOrDefault("name")
  valid_589063 = validateParameter(valid_589063, JString, required = true,
                                 default = nil)
  if valid_589063 != nil:
    section.add "name", valid_589063
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
  var valid_589064 = query.getOrDefault("upload_protocol")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "upload_protocol", valid_589064
  var valid_589065 = query.getOrDefault("fields")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "fields", valid_589065
  var valid_589066 = query.getOrDefault("quotaUser")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "quotaUser", valid_589066
  var valid_589067 = query.getOrDefault("alt")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = newJString("json"))
  if valid_589067 != nil:
    section.add "alt", valid_589067
  var valid_589068 = query.getOrDefault("oauth_token")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "oauth_token", valid_589068
  var valid_589069 = query.getOrDefault("callback")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "callback", valid_589069
  var valid_589070 = query.getOrDefault("access_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "access_token", valid_589070
  var valid_589071 = query.getOrDefault("uploadType")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "uploadType", valid_589071
  var valid_589072 = query.getOrDefault("key")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "key", valid_589072
  var valid_589073 = query.getOrDefault("$.xgafv")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = newJString("1"))
  if valid_589073 != nil:
    section.add "$.xgafv", valid_589073
  var valid_589074 = query.getOrDefault("prettyPrint")
  valid_589074 = validateParameter(valid_589074, JBool, required = false,
                                 default = newJBool(true))
  if valid_589074 != nil:
    section.add "prettyPrint", valid_589074
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

proc call*(call_589076: Call_FirestoreProjectsDatabasesImportDocuments_589060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
  ## 
  let valid = call_589076.validator(path, query, header, formData, body)
  let scheme = call_589076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589076.url(scheme.get, call_589076.host, call_589076.base,
                         call_589076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589076, url, valid)

proc call*(call_589077: Call_FirestoreProjectsDatabasesImportDocuments_589060;
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
  var path_589078 = newJObject()
  var query_589079 = newJObject()
  var body_589080 = newJObject()
  add(query_589079, "upload_protocol", newJString(uploadProtocol))
  add(query_589079, "fields", newJString(fields))
  add(query_589079, "quotaUser", newJString(quotaUser))
  add(path_589078, "name", newJString(name))
  add(query_589079, "alt", newJString(alt))
  add(query_589079, "oauth_token", newJString(oauthToken))
  add(query_589079, "callback", newJString(callback))
  add(query_589079, "access_token", newJString(accessToken))
  add(query_589079, "uploadType", newJString(uploadType))
  add(query_589079, "key", newJString(key))
  add(query_589079, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589080 = body
  add(query_589079, "prettyPrint", newJBool(prettyPrint))
  result = call_589077.call(path_589078, query_589079, nil, nil, body_589080)

var firestoreProjectsDatabasesImportDocuments* = Call_FirestoreProjectsDatabasesImportDocuments_589060(
    name: "firestoreProjectsDatabasesImportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta2/{name}:importDocuments",
    validator: validate_FirestoreProjectsDatabasesImportDocuments_589061,
    base: "/", url: url_FirestoreProjectsDatabasesImportDocuments_589062,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589081 = ref object of OpenApiRestCall_588441
proc url_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589083(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589082(
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
  var valid_589084 = path.getOrDefault("parent")
  valid_589084 = validateParameter(valid_589084, JString, required = true,
                                 default = nil)
  if valid_589084 != nil:
    section.add "parent", valid_589084
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
  var valid_589085 = query.getOrDefault("upload_protocol")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "upload_protocol", valid_589085
  var valid_589086 = query.getOrDefault("fields")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "fields", valid_589086
  var valid_589087 = query.getOrDefault("pageToken")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "pageToken", valid_589087
  var valid_589088 = query.getOrDefault("quotaUser")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "quotaUser", valid_589088
  var valid_589089 = query.getOrDefault("alt")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = newJString("json"))
  if valid_589089 != nil:
    section.add "alt", valid_589089
  var valid_589090 = query.getOrDefault("oauth_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "oauth_token", valid_589090
  var valid_589091 = query.getOrDefault("callback")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "callback", valid_589091
  var valid_589092 = query.getOrDefault("access_token")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "access_token", valid_589092
  var valid_589093 = query.getOrDefault("uploadType")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "uploadType", valid_589093
  var valid_589094 = query.getOrDefault("key")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "key", valid_589094
  var valid_589095 = query.getOrDefault("$.xgafv")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("1"))
  if valid_589095 != nil:
    section.add "$.xgafv", valid_589095
  var valid_589096 = query.getOrDefault("pageSize")
  valid_589096 = validateParameter(valid_589096, JInt, required = false, default = nil)
  if valid_589096 != nil:
    section.add "pageSize", valid_589096
  var valid_589097 = query.getOrDefault("prettyPrint")
  valid_589097 = validateParameter(valid_589097, JBool, required = false,
                                 default = newJBool(true))
  if valid_589097 != nil:
    section.add "prettyPrint", valid_589097
  var valid_589098 = query.getOrDefault("filter")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "filter", valid_589098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589099: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the field configuration and metadata for this database.
  ## 
  ## Currently, FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ## 
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589081;
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
  var path_589101 = newJObject()
  var query_589102 = newJObject()
  add(query_589102, "upload_protocol", newJString(uploadProtocol))
  add(query_589102, "fields", newJString(fields))
  add(query_589102, "pageToken", newJString(pageToken))
  add(query_589102, "quotaUser", newJString(quotaUser))
  add(query_589102, "alt", newJString(alt))
  add(query_589102, "oauth_token", newJString(oauthToken))
  add(query_589102, "callback", newJString(callback))
  add(query_589102, "access_token", newJString(accessToken))
  add(query_589102, "uploadType", newJString(uploadType))
  add(path_589101, "parent", newJString(parent))
  add(query_589102, "key", newJString(key))
  add(query_589102, "$.xgafv", newJString(Xgafv))
  add(query_589102, "pageSize", newJInt(pageSize))
  add(query_589102, "prettyPrint", newJBool(prettyPrint))
  add(query_589102, "filter", newJString(filter))
  result = call_589100.call(path_589101, query_589102, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsFieldsList* = Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589081(
    name: "firestoreProjectsDatabasesCollectionGroupsFieldsList",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1beta2/{parent}/fields",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589082,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589083,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589125 = ref object of OpenApiRestCall_588441
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589127(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589126(
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
  var valid_589128 = path.getOrDefault("parent")
  valid_589128 = validateParameter(valid_589128, JString, required = true,
                                 default = nil)
  if valid_589128 != nil:
    section.add "parent", valid_589128
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
  var valid_589129 = query.getOrDefault("upload_protocol")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "upload_protocol", valid_589129
  var valid_589130 = query.getOrDefault("fields")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "fields", valid_589130
  var valid_589131 = query.getOrDefault("quotaUser")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "quotaUser", valid_589131
  var valid_589132 = query.getOrDefault("alt")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = newJString("json"))
  if valid_589132 != nil:
    section.add "alt", valid_589132
  var valid_589133 = query.getOrDefault("oauth_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "oauth_token", valid_589133
  var valid_589134 = query.getOrDefault("callback")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "callback", valid_589134
  var valid_589135 = query.getOrDefault("access_token")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "access_token", valid_589135
  var valid_589136 = query.getOrDefault("uploadType")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "uploadType", valid_589136
  var valid_589137 = query.getOrDefault("key")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "key", valid_589137
  var valid_589138 = query.getOrDefault("$.xgafv")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = newJString("1"))
  if valid_589138 != nil:
    section.add "$.xgafv", valid_589138
  var valid_589139 = query.getOrDefault("prettyPrint")
  valid_589139 = validateParameter(valid_589139, JBool, required = false,
                                 default = newJBool(true))
  if valid_589139 != nil:
    section.add "prettyPrint", valid_589139
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

proc call*(call_589141: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a composite index. This returns a google.longrunning.Operation
  ## which may be used to track the status of the creation. The metadata for
  ## the operation will be the type IndexOperationMetadata.
  ## 
  let valid = call_589141.validator(path, query, header, formData, body)
  let scheme = call_589141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589141.url(scheme.get, call_589141.host, call_589141.base,
                         call_589141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589141, url, valid)

proc call*(call_589142: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589125;
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
  var path_589143 = newJObject()
  var query_589144 = newJObject()
  var body_589145 = newJObject()
  add(query_589144, "upload_protocol", newJString(uploadProtocol))
  add(query_589144, "fields", newJString(fields))
  add(query_589144, "quotaUser", newJString(quotaUser))
  add(query_589144, "alt", newJString(alt))
  add(query_589144, "oauth_token", newJString(oauthToken))
  add(query_589144, "callback", newJString(callback))
  add(query_589144, "access_token", newJString(accessToken))
  add(query_589144, "uploadType", newJString(uploadType))
  add(path_589143, "parent", newJString(parent))
  add(query_589144, "key", newJString(key))
  add(query_589144, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589145 = body
  add(query_589144, "prettyPrint", newJBool(prettyPrint))
  result = call_589142.call(path_589143, query_589144, nil, nil, body_589145)

var firestoreProjectsDatabasesCollectionGroupsIndexesCreate* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589125(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesCreate",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta2/{parent}/indexes", validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589126,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589127,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589103 = ref object of OpenApiRestCall_588441
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589105(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589104(
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
  var valid_589106 = path.getOrDefault("parent")
  valid_589106 = validateParameter(valid_589106, JString, required = true,
                                 default = nil)
  if valid_589106 != nil:
    section.add "parent", valid_589106
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
  var valid_589107 = query.getOrDefault("upload_protocol")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "upload_protocol", valid_589107
  var valid_589108 = query.getOrDefault("fields")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "fields", valid_589108
  var valid_589109 = query.getOrDefault("pageToken")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "pageToken", valid_589109
  var valid_589110 = query.getOrDefault("quotaUser")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "quotaUser", valid_589110
  var valid_589111 = query.getOrDefault("alt")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("json"))
  if valid_589111 != nil:
    section.add "alt", valid_589111
  var valid_589112 = query.getOrDefault("oauth_token")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "oauth_token", valid_589112
  var valid_589113 = query.getOrDefault("callback")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "callback", valid_589113
  var valid_589114 = query.getOrDefault("access_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "access_token", valid_589114
  var valid_589115 = query.getOrDefault("uploadType")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "uploadType", valid_589115
  var valid_589116 = query.getOrDefault("key")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "key", valid_589116
  var valid_589117 = query.getOrDefault("$.xgafv")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = newJString("1"))
  if valid_589117 != nil:
    section.add "$.xgafv", valid_589117
  var valid_589118 = query.getOrDefault("pageSize")
  valid_589118 = validateParameter(valid_589118, JInt, required = false, default = nil)
  if valid_589118 != nil:
    section.add "pageSize", valid_589118
  var valid_589119 = query.getOrDefault("prettyPrint")
  valid_589119 = validateParameter(valid_589119, JBool, required = false,
                                 default = newJBool(true))
  if valid_589119 != nil:
    section.add "prettyPrint", valid_589119
  var valid_589120 = query.getOrDefault("filter")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "filter", valid_589120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589121: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists composite indexes.
  ## 
  let valid = call_589121.validator(path, query, header, formData, body)
  let scheme = call_589121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589121.url(scheme.get, call_589121.host, call_589121.base,
                         call_589121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589121, url, valid)

proc call*(call_589122: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589103;
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
  var path_589123 = newJObject()
  var query_589124 = newJObject()
  add(query_589124, "upload_protocol", newJString(uploadProtocol))
  add(query_589124, "fields", newJString(fields))
  add(query_589124, "pageToken", newJString(pageToken))
  add(query_589124, "quotaUser", newJString(quotaUser))
  add(query_589124, "alt", newJString(alt))
  add(query_589124, "oauth_token", newJString(oauthToken))
  add(query_589124, "callback", newJString(callback))
  add(query_589124, "access_token", newJString(accessToken))
  add(query_589124, "uploadType", newJString(uploadType))
  add(path_589123, "parent", newJString(parent))
  add(query_589124, "key", newJString(key))
  add(query_589124, "$.xgafv", newJString(Xgafv))
  add(query_589124, "pageSize", newJInt(pageSize))
  add(query_589124, "prettyPrint", newJBool(prettyPrint))
  add(query_589124, "filter", newJString(filter))
  result = call_589122.call(path_589123, query_589124, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsIndexesList* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589103(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesList",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1beta2/{parent}/indexes",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589104,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589105,
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
