
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
  gcpServiceName = "firestore"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_578610 = ref object of OpenApiRestCall_578339
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_578612(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_578611(
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
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("callback")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "callback", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("access_token")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "access_token", valid_578761
  var valid_578762 = query.getOrDefault("upload_protocol")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "upload_protocol", valid_578762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578785: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a composite index.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_578610;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsIndexesGet
  ## Gets a composite index.
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
  ##   name: string (required)
  ##       : A name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}/indexes/{index_id}`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578857 = newJObject()
  var query_578859 = newJObject()
  add(query_578859, "key", newJString(key))
  add(query_578859, "prettyPrint", newJBool(prettyPrint))
  add(query_578859, "oauth_token", newJString(oauthToken))
  add(query_578859, "$.xgafv", newJString(Xgafv))
  add(query_578859, "alt", newJString(alt))
  add(query_578859, "uploadType", newJString(uploadType))
  add(query_578859, "quotaUser", newJString(quotaUser))
  add(path_578857, "name", newJString(name))
  add(query_578859, "callback", newJString(callback))
  add(query_578859, "fields", newJString(fields))
  add(query_578859, "access_token", newJString(accessToken))
  add(query_578859, "upload_protocol", newJString(uploadProtocol))
  result = call_578856.call(path_578857, query_578859, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsIndexesGet* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_578610(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesGet",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_578611,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesGet_578612,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_578917 = ref object of OpenApiRestCall_578339
proc url_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_578919(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_578918(
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
  var valid_578920 = path.getOrDefault("name")
  valid_578920 = validateParameter(valid_578920, JString, required = true,
                                 default = nil)
  if valid_578920 != nil:
    section.add "name", valid_578920
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
  ##   updateMask: JString
  ##             : A mask, relative to the field. If specified, only configuration specified
  ## by this field_mask will be updated in the field.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578921 = query.getOrDefault("key")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "key", valid_578921
  var valid_578922 = query.getOrDefault("prettyPrint")
  valid_578922 = validateParameter(valid_578922, JBool, required = false,
                                 default = newJBool(true))
  if valid_578922 != nil:
    section.add "prettyPrint", valid_578922
  var valid_578923 = query.getOrDefault("oauth_token")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "oauth_token", valid_578923
  var valid_578924 = query.getOrDefault("$.xgafv")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = newJString("1"))
  if valid_578924 != nil:
    section.add "$.xgafv", valid_578924
  var valid_578925 = query.getOrDefault("alt")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = newJString("json"))
  if valid_578925 != nil:
    section.add "alt", valid_578925
  var valid_578926 = query.getOrDefault("uploadType")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "uploadType", valid_578926
  var valid_578927 = query.getOrDefault("quotaUser")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "quotaUser", valid_578927
  var valid_578928 = query.getOrDefault("updateMask")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "updateMask", valid_578928
  var valid_578929 = query.getOrDefault("callback")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "callback", valid_578929
  var valid_578930 = query.getOrDefault("fields")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "fields", valid_578930
  var valid_578931 = query.getOrDefault("access_token")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "access_token", valid_578931
  var valid_578932 = query.getOrDefault("upload_protocol")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "upload_protocol", valid_578932
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

proc call*(call_578934: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_578917;
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
  let valid = call_578934.validator(path, query, header, formData, body)
  let scheme = call_578934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578934.url(scheme.get, call_578934.host, call_578934.base,
                         call_578934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578934, url, valid)

proc call*(call_578935: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_578917;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   updateMask: string
  ##             : A mask, relative to the field. If specified, only configuration specified
  ## by this field_mask will be updated in the field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578936 = newJObject()
  var query_578937 = newJObject()
  var body_578938 = newJObject()
  add(query_578937, "key", newJString(key))
  add(query_578937, "prettyPrint", newJBool(prettyPrint))
  add(query_578937, "oauth_token", newJString(oauthToken))
  add(query_578937, "$.xgafv", newJString(Xgafv))
  add(query_578937, "alt", newJString(alt))
  add(query_578937, "uploadType", newJString(uploadType))
  add(query_578937, "quotaUser", newJString(quotaUser))
  add(path_578936, "name", newJString(name))
  add(query_578937, "updateMask", newJString(updateMask))
  if body != nil:
    body_578938 = body
  add(query_578937, "callback", newJString(callback))
  add(query_578937, "fields", newJString(fields))
  add(query_578937, "access_token", newJString(accessToken))
  add(query_578937, "upload_protocol", newJString(uploadProtocol))
  result = call_578935.call(path_578936, query_578937, nil, nil, body_578938)

var firestoreProjectsDatabasesCollectionGroupsFieldsPatch* = Call_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_578917(
    name: "firestoreProjectsDatabasesCollectionGroupsFieldsPatch",
    meth: HttpMethod.HttpPatch, host: "firestore.googleapis.com",
    route: "/v1beta2/{name}",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_578918,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsFieldsPatch_578919,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_578898 = ref object of OpenApiRestCall_578339
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_578900(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_578899(
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
  var valid_578901 = path.getOrDefault("name")
  valid_578901 = validateParameter(valid_578901, JString, required = true,
                                 default = nil)
  if valid_578901 != nil:
    section.add "name", valid_578901
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
  var valid_578902 = query.getOrDefault("key")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "key", valid_578902
  var valid_578903 = query.getOrDefault("prettyPrint")
  valid_578903 = validateParameter(valid_578903, JBool, required = false,
                                 default = newJBool(true))
  if valid_578903 != nil:
    section.add "prettyPrint", valid_578903
  var valid_578904 = query.getOrDefault("oauth_token")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "oauth_token", valid_578904
  var valid_578905 = query.getOrDefault("$.xgafv")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("1"))
  if valid_578905 != nil:
    section.add "$.xgafv", valid_578905
  var valid_578906 = query.getOrDefault("alt")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("json"))
  if valid_578906 != nil:
    section.add "alt", valid_578906
  var valid_578907 = query.getOrDefault("uploadType")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "uploadType", valid_578907
  var valid_578908 = query.getOrDefault("quotaUser")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "quotaUser", valid_578908
  var valid_578909 = query.getOrDefault("callback")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "callback", valid_578909
  var valid_578910 = query.getOrDefault("fields")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "fields", valid_578910
  var valid_578911 = query.getOrDefault("access_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "access_token", valid_578911
  var valid_578912 = query.getOrDefault("upload_protocol")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "upload_protocol", valid_578912
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578913: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_578898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a composite index.
  ## 
  let valid = call_578913.validator(path, query, header, formData, body)
  let scheme = call_578913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578913.url(scheme.get, call_578913.host, call_578913.base,
                         call_578913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578913, url, valid)

proc call*(call_578914: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_578898;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsIndexesDelete
  ## Deletes a composite index.
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
  ##   name: string (required)
  ##       : A name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}/indexes/{index_id}`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578915 = newJObject()
  var query_578916 = newJObject()
  add(query_578916, "key", newJString(key))
  add(query_578916, "prettyPrint", newJBool(prettyPrint))
  add(query_578916, "oauth_token", newJString(oauthToken))
  add(query_578916, "$.xgafv", newJString(Xgafv))
  add(query_578916, "alt", newJString(alt))
  add(query_578916, "uploadType", newJString(uploadType))
  add(query_578916, "quotaUser", newJString(quotaUser))
  add(path_578915, "name", newJString(name))
  add(query_578916, "callback", newJString(callback))
  add(query_578916, "fields", newJString(fields))
  add(query_578916, "access_token", newJString(accessToken))
  add(query_578916, "upload_protocol", newJString(uploadProtocol))
  result = call_578914.call(path_578915, query_578916, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsIndexesDelete* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_578898(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesDelete",
    meth: HttpMethod.HttpDelete, host: "firestore.googleapis.com",
    route: "/v1beta2/{name}", validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_578899,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesDelete_578900,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesExportDocuments_578939 = ref object of OpenApiRestCall_578339
proc url_FirestoreProjectsDatabasesExportDocuments_578941(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesExportDocuments_578940(path: JsonNode;
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
  var valid_578942 = path.getOrDefault("name")
  valid_578942 = validateParameter(valid_578942, JString, required = true,
                                 default = nil)
  if valid_578942 != nil:
    section.add "name", valid_578942
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
  var valid_578943 = query.getOrDefault("key")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "key", valid_578943
  var valid_578944 = query.getOrDefault("prettyPrint")
  valid_578944 = validateParameter(valid_578944, JBool, required = false,
                                 default = newJBool(true))
  if valid_578944 != nil:
    section.add "prettyPrint", valid_578944
  var valid_578945 = query.getOrDefault("oauth_token")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "oauth_token", valid_578945
  var valid_578946 = query.getOrDefault("$.xgafv")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("1"))
  if valid_578946 != nil:
    section.add "$.xgafv", valid_578946
  var valid_578947 = query.getOrDefault("alt")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("json"))
  if valid_578947 != nil:
    section.add "alt", valid_578947
  var valid_578948 = query.getOrDefault("uploadType")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "uploadType", valid_578948
  var valid_578949 = query.getOrDefault("quotaUser")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "quotaUser", valid_578949
  var valid_578950 = query.getOrDefault("callback")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "callback", valid_578950
  var valid_578951 = query.getOrDefault("fields")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "fields", valid_578951
  var valid_578952 = query.getOrDefault("access_token")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "access_token", valid_578952
  var valid_578953 = query.getOrDefault("upload_protocol")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "upload_protocol", valid_578953
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

proc call*(call_578955: Call_FirestoreProjectsDatabasesExportDocuments_578939;
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
  let valid = call_578955.validator(path, query, header, formData, body)
  let scheme = call_578955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578955.url(scheme.get, call_578955.host, call_578955.base,
                         call_578955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578955, url, valid)

proc call*(call_578956: Call_FirestoreProjectsDatabasesExportDocuments_578939;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesExportDocuments
  ## Exports a copy of all or a subset of documents from Google Cloud Firestore
  ## to another storage system, such as Google Cloud Storage. Recent updates to
  ## documents may not be reflected in the export. The export occurs in the
  ## background and its progress can be monitored and managed via the
  ## Operation resource that is created. The output of an export may only be
  ## used once the associated operation is done. If an export operation is
  ## cancelled before completion it may leave partial data behind in Google
  ## Cloud Storage.
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
  ##   name: string (required)
  ##       : Database to export. Should be of the form:
  ## `projects/{project_id}/databases/{database_id}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578957 = newJObject()
  var query_578958 = newJObject()
  var body_578959 = newJObject()
  add(query_578958, "key", newJString(key))
  add(query_578958, "prettyPrint", newJBool(prettyPrint))
  add(query_578958, "oauth_token", newJString(oauthToken))
  add(query_578958, "$.xgafv", newJString(Xgafv))
  add(query_578958, "alt", newJString(alt))
  add(query_578958, "uploadType", newJString(uploadType))
  add(query_578958, "quotaUser", newJString(quotaUser))
  add(path_578957, "name", newJString(name))
  if body != nil:
    body_578959 = body
  add(query_578958, "callback", newJString(callback))
  add(query_578958, "fields", newJString(fields))
  add(query_578958, "access_token", newJString(accessToken))
  add(query_578958, "upload_protocol", newJString(uploadProtocol))
  result = call_578956.call(path_578957, query_578958, nil, nil, body_578959)

var firestoreProjectsDatabasesExportDocuments* = Call_FirestoreProjectsDatabasesExportDocuments_578939(
    name: "firestoreProjectsDatabasesExportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta2/{name}:exportDocuments",
    validator: validate_FirestoreProjectsDatabasesExportDocuments_578940,
    base: "/", url: url_FirestoreProjectsDatabasesExportDocuments_578941,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesImportDocuments_578960 = ref object of OpenApiRestCall_578339
proc url_FirestoreProjectsDatabasesImportDocuments_578962(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesImportDocuments_578961(path: JsonNode;
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
  var valid_578963 = path.getOrDefault("name")
  valid_578963 = validateParameter(valid_578963, JString, required = true,
                                 default = nil)
  if valid_578963 != nil:
    section.add "name", valid_578963
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
  var valid_578964 = query.getOrDefault("key")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "key", valid_578964
  var valid_578965 = query.getOrDefault("prettyPrint")
  valid_578965 = validateParameter(valid_578965, JBool, required = false,
                                 default = newJBool(true))
  if valid_578965 != nil:
    section.add "prettyPrint", valid_578965
  var valid_578966 = query.getOrDefault("oauth_token")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "oauth_token", valid_578966
  var valid_578967 = query.getOrDefault("$.xgafv")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("1"))
  if valid_578967 != nil:
    section.add "$.xgafv", valid_578967
  var valid_578968 = query.getOrDefault("alt")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("json"))
  if valid_578968 != nil:
    section.add "alt", valid_578968
  var valid_578969 = query.getOrDefault("uploadType")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "uploadType", valid_578969
  var valid_578970 = query.getOrDefault("quotaUser")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "quotaUser", valid_578970
  var valid_578971 = query.getOrDefault("callback")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "callback", valid_578971
  var valid_578972 = query.getOrDefault("fields")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "fields", valid_578972
  var valid_578973 = query.getOrDefault("access_token")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "access_token", valid_578973
  var valid_578974 = query.getOrDefault("upload_protocol")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "upload_protocol", valid_578974
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

proc call*(call_578976: Call_FirestoreProjectsDatabasesImportDocuments_578960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
  ## 
  let valid = call_578976.validator(path, query, header, formData, body)
  let scheme = call_578976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578976.url(scheme.get, call_578976.host, call_578976.base,
                         call_578976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578976, url, valid)

proc call*(call_578977: Call_FirestoreProjectsDatabasesImportDocuments_578960;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesImportDocuments
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
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
  ##   name: string (required)
  ##       : Database to import into. Should be of the form:
  ## `projects/{project_id}/databases/{database_id}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578978 = newJObject()
  var query_578979 = newJObject()
  var body_578980 = newJObject()
  add(query_578979, "key", newJString(key))
  add(query_578979, "prettyPrint", newJBool(prettyPrint))
  add(query_578979, "oauth_token", newJString(oauthToken))
  add(query_578979, "$.xgafv", newJString(Xgafv))
  add(query_578979, "alt", newJString(alt))
  add(query_578979, "uploadType", newJString(uploadType))
  add(query_578979, "quotaUser", newJString(quotaUser))
  add(path_578978, "name", newJString(name))
  if body != nil:
    body_578980 = body
  add(query_578979, "callback", newJString(callback))
  add(query_578979, "fields", newJString(fields))
  add(query_578979, "access_token", newJString(accessToken))
  add(query_578979, "upload_protocol", newJString(uploadProtocol))
  result = call_578977.call(path_578978, query_578979, nil, nil, body_578980)

var firestoreProjectsDatabasesImportDocuments* = Call_FirestoreProjectsDatabasesImportDocuments_578960(
    name: "firestoreProjectsDatabasesImportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta2/{name}:importDocuments",
    validator: validate_FirestoreProjectsDatabasesImportDocuments_578961,
    base: "/", url: url_FirestoreProjectsDatabasesImportDocuments_578962,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_578981 = ref object of OpenApiRestCall_578339
proc url_FirestoreProjectsDatabasesCollectionGroupsFieldsList_578983(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsFieldsList_578982(
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
  var valid_578984 = path.getOrDefault("parent")
  valid_578984 = validateParameter(valid_578984, JString, required = true,
                                 default = nil)
  if valid_578984 != nil:
    section.add "parent", valid_578984
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
  ##           : The number of results to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter to apply to list results. Currently,
  ## FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ##   pageToken: JString
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListFields, that may be used to get the next
  ## page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578985 = query.getOrDefault("key")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "key", valid_578985
  var valid_578986 = query.getOrDefault("prettyPrint")
  valid_578986 = validateParameter(valid_578986, JBool, required = false,
                                 default = newJBool(true))
  if valid_578986 != nil:
    section.add "prettyPrint", valid_578986
  var valid_578987 = query.getOrDefault("oauth_token")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "oauth_token", valid_578987
  var valid_578988 = query.getOrDefault("$.xgafv")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("1"))
  if valid_578988 != nil:
    section.add "$.xgafv", valid_578988
  var valid_578989 = query.getOrDefault("pageSize")
  valid_578989 = validateParameter(valid_578989, JInt, required = false, default = nil)
  if valid_578989 != nil:
    section.add "pageSize", valid_578989
  var valid_578990 = query.getOrDefault("alt")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("json"))
  if valid_578990 != nil:
    section.add "alt", valid_578990
  var valid_578991 = query.getOrDefault("uploadType")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "uploadType", valid_578991
  var valid_578992 = query.getOrDefault("quotaUser")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "quotaUser", valid_578992
  var valid_578993 = query.getOrDefault("filter")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "filter", valid_578993
  var valid_578994 = query.getOrDefault("pageToken")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "pageToken", valid_578994
  var valid_578995 = query.getOrDefault("callback")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "callback", valid_578995
  var valid_578996 = query.getOrDefault("fields")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "fields", valid_578996
  var valid_578997 = query.getOrDefault("access_token")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "access_token", valid_578997
  var valid_578998 = query.getOrDefault("upload_protocol")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "upload_protocol", valid_578998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578999: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_578981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the field configuration and metadata for this database.
  ## 
  ## Currently, FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ## 
  let valid = call_578999.validator(path, query, header, formData, body)
  let scheme = call_578999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578999.url(scheme.get, call_578999.host, call_578999.base,
                         call_578999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578999, url, valid)

proc call*(call_579000: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_578981;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsFieldsList
  ## Lists the field configuration and metadata for this database.
  ## 
  ## Currently, FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of results to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The filter to apply to list results. Currently,
  ## FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ##   pageToken: string
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListFields, that may be used to get the next
  ## page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579001 = newJObject()
  var query_579002 = newJObject()
  add(query_579002, "key", newJString(key))
  add(query_579002, "prettyPrint", newJBool(prettyPrint))
  add(query_579002, "oauth_token", newJString(oauthToken))
  add(query_579002, "$.xgafv", newJString(Xgafv))
  add(query_579002, "pageSize", newJInt(pageSize))
  add(query_579002, "alt", newJString(alt))
  add(query_579002, "uploadType", newJString(uploadType))
  add(query_579002, "quotaUser", newJString(quotaUser))
  add(query_579002, "filter", newJString(filter))
  add(query_579002, "pageToken", newJString(pageToken))
  add(query_579002, "callback", newJString(callback))
  add(path_579001, "parent", newJString(parent))
  add(query_579002, "fields", newJString(fields))
  add(query_579002, "access_token", newJString(accessToken))
  add(query_579002, "upload_protocol", newJString(uploadProtocol))
  result = call_579000.call(path_579001, query_579002, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsFieldsList* = Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_578981(
    name: "firestoreProjectsDatabasesCollectionGroupsFieldsList",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1beta2/{parent}/fields",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsFieldsList_578982,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsFieldsList_578983,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579025 = ref object of OpenApiRestCall_578339
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579027(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579026(
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
  var valid_579028 = path.getOrDefault("parent")
  valid_579028 = validateParameter(valid_579028, JString, required = true,
                                 default = nil)
  if valid_579028 != nil:
    section.add "parent", valid_579028
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
  var valid_579029 = query.getOrDefault("key")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "key", valid_579029
  var valid_579030 = query.getOrDefault("prettyPrint")
  valid_579030 = validateParameter(valid_579030, JBool, required = false,
                                 default = newJBool(true))
  if valid_579030 != nil:
    section.add "prettyPrint", valid_579030
  var valid_579031 = query.getOrDefault("oauth_token")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "oauth_token", valid_579031
  var valid_579032 = query.getOrDefault("$.xgafv")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = newJString("1"))
  if valid_579032 != nil:
    section.add "$.xgafv", valid_579032
  var valid_579033 = query.getOrDefault("alt")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("json"))
  if valid_579033 != nil:
    section.add "alt", valid_579033
  var valid_579034 = query.getOrDefault("uploadType")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "uploadType", valid_579034
  var valid_579035 = query.getOrDefault("quotaUser")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "quotaUser", valid_579035
  var valid_579036 = query.getOrDefault("callback")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "callback", valid_579036
  var valid_579037 = query.getOrDefault("fields")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "fields", valid_579037
  var valid_579038 = query.getOrDefault("access_token")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "access_token", valid_579038
  var valid_579039 = query.getOrDefault("upload_protocol")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "upload_protocol", valid_579039
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

proc call*(call_579041: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a composite index. This returns a google.longrunning.Operation
  ## which may be used to track the status of the creation. The metadata for
  ## the operation will be the type IndexOperationMetadata.
  ## 
  let valid = call_579041.validator(path, query, header, formData, body)
  let scheme = call_579041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579041.url(scheme.get, call_579041.host, call_579041.base,
                         call_579041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579041, url, valid)

proc call*(call_579042: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579025;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsIndexesCreate
  ## Creates a composite index. This returns a google.longrunning.Operation
  ## which may be used to track the status of the creation. The metadata for
  ## the operation will be the type IndexOperationMetadata.
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
  ##   parent: string (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579043 = newJObject()
  var query_579044 = newJObject()
  var body_579045 = newJObject()
  add(query_579044, "key", newJString(key))
  add(query_579044, "prettyPrint", newJBool(prettyPrint))
  add(query_579044, "oauth_token", newJString(oauthToken))
  add(query_579044, "$.xgafv", newJString(Xgafv))
  add(query_579044, "alt", newJString(alt))
  add(query_579044, "uploadType", newJString(uploadType))
  add(query_579044, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579045 = body
  add(query_579044, "callback", newJString(callback))
  add(path_579043, "parent", newJString(parent))
  add(query_579044, "fields", newJString(fields))
  add(query_579044, "access_token", newJString(accessToken))
  add(query_579044, "upload_protocol", newJString(uploadProtocol))
  result = call_579042.call(path_579043, query_579044, nil, nil, body_579045)

var firestoreProjectsDatabasesCollectionGroupsIndexesCreate* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579025(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesCreate",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta2/{parent}/indexes", validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579026,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579027,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579003 = ref object of OpenApiRestCall_578339
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579005(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579004(
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
  var valid_579006 = path.getOrDefault("parent")
  valid_579006 = validateParameter(valid_579006, JString, required = true,
                                 default = nil)
  if valid_579006 != nil:
    section.add "parent", valid_579006
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
  ##           : The number of results to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter to apply to list results.
  ##   pageToken: JString
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListIndexes, that may be used to get the next
  ## page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579007 = query.getOrDefault("key")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "key", valid_579007
  var valid_579008 = query.getOrDefault("prettyPrint")
  valid_579008 = validateParameter(valid_579008, JBool, required = false,
                                 default = newJBool(true))
  if valid_579008 != nil:
    section.add "prettyPrint", valid_579008
  var valid_579009 = query.getOrDefault("oauth_token")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "oauth_token", valid_579009
  var valid_579010 = query.getOrDefault("$.xgafv")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = newJString("1"))
  if valid_579010 != nil:
    section.add "$.xgafv", valid_579010
  var valid_579011 = query.getOrDefault("pageSize")
  valid_579011 = validateParameter(valid_579011, JInt, required = false, default = nil)
  if valid_579011 != nil:
    section.add "pageSize", valid_579011
  var valid_579012 = query.getOrDefault("alt")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = newJString("json"))
  if valid_579012 != nil:
    section.add "alt", valid_579012
  var valid_579013 = query.getOrDefault("uploadType")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "uploadType", valid_579013
  var valid_579014 = query.getOrDefault("quotaUser")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "quotaUser", valid_579014
  var valid_579015 = query.getOrDefault("filter")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "filter", valid_579015
  var valid_579016 = query.getOrDefault("pageToken")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "pageToken", valid_579016
  var valid_579017 = query.getOrDefault("callback")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "callback", valid_579017
  var valid_579018 = query.getOrDefault("fields")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "fields", valid_579018
  var valid_579019 = query.getOrDefault("access_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "access_token", valid_579019
  var valid_579020 = query.getOrDefault("upload_protocol")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "upload_protocol", valid_579020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579021: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists composite indexes.
  ## 
  let valid = call_579021.validator(path, query, header, formData, body)
  let scheme = call_579021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579021.url(scheme.get, call_579021.host, call_579021.base,
                         call_579021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579021, url, valid)

proc call*(call_579022: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579003;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsIndexesList
  ## Lists composite indexes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of results to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The filter to apply to list results.
  ##   pageToken: string
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListIndexes, that may be used to get the next
  ## page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579023 = newJObject()
  var query_579024 = newJObject()
  add(query_579024, "key", newJString(key))
  add(query_579024, "prettyPrint", newJBool(prettyPrint))
  add(query_579024, "oauth_token", newJString(oauthToken))
  add(query_579024, "$.xgafv", newJString(Xgafv))
  add(query_579024, "pageSize", newJInt(pageSize))
  add(query_579024, "alt", newJString(alt))
  add(query_579024, "uploadType", newJString(uploadType))
  add(query_579024, "quotaUser", newJString(quotaUser))
  add(query_579024, "filter", newJString(filter))
  add(query_579024, "pageToken", newJString(pageToken))
  add(query_579024, "callback", newJString(callback))
  add(path_579023, "parent", newJString(parent))
  add(query_579024, "fields", newJString(fields))
  add(query_579024, "access_token", newJString(accessToken))
  add(query_579024, "upload_protocol", newJString(uploadProtocol))
  result = call_579022.call(path_579023, query_579024, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsIndexesList* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579003(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesList",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1beta2/{parent}/indexes",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579004,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579005,
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
